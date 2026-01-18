package loginServlet;

import com.example.db.DBConnection;
import com.example.util.EmailUtil;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ForgotPasswordServlet")
public class PrincipalForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String empNumber = request.getParameter("employee_number");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT id, email, principal_name, approved, rejected FROM principals WHERE employee_number=?"
            );
            ps.setString(1, empNumber);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                request.setAttribute("error", "Employee number not found.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
                return;
            }

            boolean approved = rs.getBoolean("approved");
            boolean rejected = rs.getBoolean("rejected");
            int principalId = rs.getInt("id");
            String email = rs.getString("email");
            String name = rs.getString("principal_name");

            // Check approval / rejection status
            if (rejected) {
                request.setAttribute("error", "Your account has been rejected. Cannot reset password.");
                request.getRequestDispatcher("principal_login.jsp").forward(request, response);
                return;
            }

            if (!approved) {
                request.setAttribute("error", "Your account is pending approval. Cannot reset password yet.");
                request.getRequestDispatcher("principal_login.jsp").forward(request, response);
                return;
            }

            // Update password in DB
            PreparedStatement update = conn.prepareStatement(
                "UPDATE principals SET password=? WHERE id=?"
            );
            update.setString(1, newPassword);
            update.setInt(2, principalId);
            int updated = update.executeUpdate();

            if (updated > 0) {
                // Send email notification
                String subject = "Your Password Has Been Changed";
                String message = "Hello " + name + ",\n\nYour password has been successfully updated.\n\n" +
                        "If you did not request this change, please contact the admin immediately.\n\n" +
                        "Regards,\nSchool Donation Management System";

                try {
                    EmailUtil.sendEmail(email, subject, message);
                    request.setAttribute("success", "Password changed successfully. A confirmation email has been sent.");
                } catch (MessagingException e) {
                    request.setAttribute("success", "Password changed, but email could not be sent.");
                    e.printStackTrace();
                }

                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);

            } else {
                request.setAttribute("error", "Failed to update password. Try again.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error. Please try again later.");
            request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
        }
    }
}
