package admin;

import com.example.db.DBConnection;
import com.example.util.EmailUtil;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/PrincipalRejectServlet")
public class PrincipalRejectServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String reason = request.getParameter("reason");

        if(idStr == null || reason == null || reason.trim().isEmpty()) {
            request.getSession().setAttribute("msg", "Invalid rejection data.");
            response.sendRedirect("admin_principals.jsp");
            return;
        }

        int id = Integer.parseInt(idStr);

        try (Connection conn = DBConnection.getConnection()) {

            // Get principal email and name
            String principalEmail = null;
            String principalName = null;
            try (PreparedStatement psSelect = conn.prepareStatement(
                    "SELECT email, principal_name FROM principals WHERE id = ?"
            )) {
                psSelect.setInt(1, id);
                ResultSet rs = psSelect.executeQuery();
                if(rs.next()) {
                    principalEmail = rs.getString("email");
                    principalName = rs.getString("principal_name");
                }
            }

            if(principalEmail == null) {
                request.getSession().setAttribute("msg", "Principal not found.");
                response.sendRedirect("admin_principals.jsp");
                return;
            }

            // Update principal as rejected
            try (PreparedStatement psUpdate = conn.prepareStatement(
                    "UPDATE principals SET rejected = 1, approved_at = NOW() WHERE id = ?"
            )) {
                psUpdate.setInt(1, id);
                psUpdate.executeUpdate();
            }

            // Send rejection email
            try {
                String subject = "Your Principal Account Application was Rejected";
                String message = "Hello " + principalName + ",\n\n" +
                                 "Your principal account request has been rejected.\n" +
                                 "Reason: " + reason + "\n\n" +
                                 "Regards,\nDonorSchool - School Donation App Team";

                EmailUtil.sendEmail(principalEmail, subject, message);
                request.getSession().setAttribute("msg", "Principal rejected and email sent successfully.");
            } catch (MessagingException e) {
                e.printStackTrace();
                request.getSession().setAttribute("msg", "Principal rejected, but failed to send email: " + e.getMessage());
            }

            response.sendRedirect("admin_principals.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("msg", "Database error: " + e.getMessage());
            response.sendRedirect("admin_principals.jsp");
        }
    }
}
