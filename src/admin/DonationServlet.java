package admin;

import com.example.db.DBConnection;
import com.example.util.EmailUtil;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/DonationServlet")
@MultipartConfig
public class DonationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String username = request.getParameter("username");
        BigDecimal donatedAmount = new BigDecimal(request.getParameter("amount"));

        // Upload folder inside the webapp
        String uploadPath = request.getServletContext().getRealPath("/") + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        Part receiptPart = request.getPart("receipt");
        String receiptFileName = null;

        if (receiptPart != null && receiptPart.getSize() > 0) {
            String originalName = Paths.get(receiptPart.getSubmittedFileName()).getFileName().toString();
            receiptFileName = System.currentTimeMillis() + "_" + originalName;
            receiptPart.write(new File(uploadDir, receiptFileName).getAbsolutePath());
        }

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            // Lock row to prevent race conditions
            PreparedStatement ps1 = conn.prepareStatement(
                    "SELECT amount_needed, status, principal_id FROM school_requests WHERE id=? FOR UPDATE"
            );
            ps1.setInt(1, requestId);
            ResultSet rs = ps1.executeQuery();

            if (!rs.next()) {
                conn.rollback();
                response.getWriter().println("Invalid request.");
                return;
            }

            BigDecimal remaining = rs.getBigDecimal("amount_needed");
            String status = rs.getString("status");
            int principalId = rs.getInt("principal_id");

            // If already fulfilled, block donation
            if (!"open".equalsIgnoreCase(status) && !"reserved".equalsIgnoreCase(status)) {
                conn.rollback();
                response.getWriter().println("This request is already fulfilled.");
                return;
            }

            // If donation exceeds remaining amount
            if (donatedAmount.compareTo(remaining) > 0) {
                // Update school_requests to fulfilled
                PreparedStatement psUpdate = conn.prepareStatement(
                        "UPDATE school_requests SET amount_needed=0, status='fulfilled' WHERE id=?"
                );
                psUpdate.setInt(1, requestId);
                psUpdate.executeUpdate();

                // Get principal email
                PreparedStatement psPrincipal = conn.prepareStatement(
                        "SELECT email FROM principals WHERE id=?"
                );
                psPrincipal.setInt(1, principalId);
                ResultSet rsPrincipal = psPrincipal.executeQuery();
                if (rsPrincipal.next()) {
                    String principalEmail = rsPrincipal.getString("email");

                    // Send email notification
                    String subject = "Your donation request has been fulfilled";
                    String message = "Hello,\n\n" +
                            "The requested amount for your school need (ID: " + requestId + ") has been exceeded by a donor.\n" +
                            "The request has now been marked as fulfilled.\n\n" +
                            "Regards,\nSchool Donation App";
                    try {
                        EmailUtil.sendEmail(principalEmail, subject, message);
                    } catch (MessagingException e) {
                        e.printStackTrace();
                    }
                }

                conn.commit();
                response.getWriter().println("Donation exceeds remaining amount. Principal notified, request fulfilled.");
                return;
            }

            // Add donation record
            PreparedStatement ps2 = conn.prepareStatement(
                    "INSERT INTO donations (donor_username, request_id, amount, receipt_file) VALUES (?,?,?,?)"
            );
            ps2.setString(1, username);
            ps2.setInt(2, requestId);
            ps2.setBigDecimal(3, donatedAmount);
            ps2.setString(4, receiptFileName);
            ps2.executeUpdate();

            // New remaining amount
            BigDecimal newRemaining = remaining.subtract(donatedAmount);

            PreparedStatement ps3;
            if (newRemaining.compareTo(BigDecimal.ZERO) <= 0) {
                ps3 = conn.prepareStatement(
                        "UPDATE school_requests SET amount_needed=0, status='fulfilled' WHERE id=?"
                );
                ps3.setInt(1, requestId);

                // Notify principal that request is fulfilled
                PreparedStatement psPrincipal = conn.prepareStatement(
                        "SELECT email FROM principals WHERE id=?"
                );
                psPrincipal.setInt(1, principalId);
                ResultSet rsPrincipal = psPrincipal.executeQuery();
                if (rsPrincipal.next()) {
                    String principalEmail = rsPrincipal.getString("email");
                    String subject = "Your donation request has been fulfilled";
                    String message = "Hello,\n\n" +
                            "The requested amount for your school need (ID: " + requestId + ") has been fully funded.\n" +
                            "Thank you for using School Donation App.\n\n" +
                            "Regards,\nSchool Donation App";
                    try {
                        EmailUtil.sendEmail(principalEmail, subject, message);
                    } catch (MessagingException e) {
                        e.printStackTrace();
                    }
                }

            } else {
                ps3 = conn.prepareStatement(
                        "UPDATE school_requests SET amount_needed=? WHERE id=?"
                );
                ps3.setBigDecimal(1, newRemaining);
                ps3.setInt(2, requestId);
            }

            ps3.executeUpdate();

            conn.commit();
            response.sendRedirect(request.getContextPath() + "/donor_dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}
