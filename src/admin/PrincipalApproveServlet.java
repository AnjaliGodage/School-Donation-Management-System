package admin;

import com.example.db.DBConnection;
import com.example.util.EmailUtil;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/PrincipalApproveServlet")
public class PrincipalApproveServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String idStr = request.getParameter("id");

        if(idStr == null || idStr.isEmpty()) {
            session.setAttribute("msg", "Invalid principal ID");
            response.sendRedirect("admin_principals.jsp");
            return;
        }

        int id = Integer.parseInt(idStr);

        try (Connection conn = DBConnection.getConnection()) {
            // Fetch principal email
            PreparedStatement psFetch = conn.prepareStatement("SELECT email, principal_name FROM principals WHERE id=?");
            psFetch.setInt(1, id);
            ResultSet rs = psFetch.executeQuery();

            if(rs.next()) {
                String email = rs.getString("email");
                String name = rs.getString("principal_name");

                // Update approved status
                PreparedStatement psUpdate = conn.prepareStatement(
                        "UPDATE principals SET approved=true, approved_at=NOW() WHERE id=?"
                );
                psUpdate.setInt(1, id);
                psUpdate.executeUpdate();

                // Send approval email
                try {
                    String subject = "Principal Account Approved";
                    String message = "Dear " + name + ",\nYour principal account has been approved. You can now login.\n\nRegards,\nDonorSchool - School Donation System";
                    EmailUtil.sendEmail(email, subject, message);
                    session.setAttribute("msg", "Principal approved and email sent!");
                } catch (MessagingException e) {
                    e.printStackTrace();
                    session.setAttribute("msg", "Principal approved, but failed to send email: " + e.getMessage());
                }

            } else {
                session.setAttribute("msg", "Principal not found!");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("msg", "Database error: " + e.getMessage());
        }

        response.sendRedirect("admin_principals.jsp");
    }
}
