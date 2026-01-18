package loginServlet;

import com.example.db.DBConnection;
import com.example.util.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/DonorForgotPasswordServlet")
public class DonorForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");

        try (Connection conn = DBConnection.getConnection()) {

            // Check if username and email both exist
            PreparedStatement psCheck = conn.prepareStatement(
                    "SELECT * FROM donors WHERE username=? AND email=?"
            );
            psCheck.setString(1, username);
            psCheck.setString(2, email);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // Both match, update password
                PreparedStatement psUpdate = conn.prepareStatement(
                        "UPDATE donors SET password=? WHERE username=? AND email=?"
                );
                psUpdate.setString(1, newPassword); // For production, hash this
                psUpdate.setString(2, username);
                psUpdate.setString(3, email);
                psUpdate.executeUpdate();

                // Send confirmation email
                String firstName = rs.getString("first_name");
                String subject = "Password Reset Notification";
                String messageText = "Hello " + firstName + ",\n\n"
                        + "Your password has been successfully reset.\n"
                        + "If you did not perform this action, contact support immediately.\n\n"
                        + "Thank you,\nSchool Donation Management System";

                try {
                    EmailUtil.sendEmail(email, subject, messageText);
                    request.setAttribute("success", "Password reset successfully and email sent!");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("success", "Password reset successfully, but email failed to send.");
                }

            } else {
                request.setAttribute("error", "Username and Email do not match or do not exist.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
        }

        // Forward to JSP
        request.getRequestDispatcher("donor_forgot_password.jsp").forward(request, response);
    }
}
