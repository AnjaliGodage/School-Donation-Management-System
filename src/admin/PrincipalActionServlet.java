package admin;

import com.example.db.DBConnection;
import com.example.util.EmailUtil;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/PrincipalActionServlet")
public class PrincipalActionServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (action == null || idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect("admin_principals.jsp?error=Invalid request");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("admin_principals.jsp?error=Invalid ID");
            return;
        }

        String principalEmail = null;
        String principalName = null;

        try (Connection conn = DBConnection.getConnection()) {

            // Fetch principal details
            String sqlFetch = "SELECT principal_name, email FROM principals WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlFetch)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        principalName = rs.getString("principal_name");
                        principalEmail = rs.getString("email");
                    } else {
                        response.sendRedirect("admin_principals.jsp?error=Principal not found");
                        return;
                    }
                }
            }

            if ("approve".equals(action)) {
                // Approve principal
                String sqlApprove = "UPDATE principals SET approved = 1, approved_at = NOW(), rejected_at = NULL, rejection_reason = NULL WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlApprove)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }

                // Send approval email
                if (principalEmail != null) {
                    String subject = "Your Principal Account Has Been Approved";
                    String body = "Hello " + principalName + ",\n\n"
                            + "Your account has been approved by the admin.\n"
                            + "You may now log in and access the system.\n\n"
                            + "Regards,\nAdmin Team";
                    try {
                        EmailUtil.sendEmail(principalEmail, subject, body);
                    } catch (MessagingException e) {
                        e.printStackTrace();
                    }
                }

            } else if ("reject".equals(action)) {
                // Reject principal
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().isEmpty()) {
                    reason = "Rejected by admin.";
                }

                String sqlReject = "UPDATE principals SET approved = 0, rejected_at = NOW(), rejection_reason = ? WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlReject)) {
                    ps.setString(1, reason);
                    ps.setInt(2, id);
                    ps.executeUpdate();
                }

                // Send rejection email
                if (principalEmail != null) {
                    String subject = "Your Principal Account Has Been Rejected";
                    String body = "Hello " + principalName + ",\n\n"
                            + "Your account has been rejected.\n"
                            + "Reason: " + reason + "\n\n"
                            + "Regards,\nAdmin Team";
                    try {
                        EmailUtil.sendEmail(principalEmail, subject, body);
                    } catch (MessagingException e) {
                        e.printStackTrace();
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("admin_principals.jsp?error=Database error");
            return;
        }

        response.sendRedirect("admin_principals.jsp?msg=Action completed");
    }
}
