package admin;

import com.example.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/PrincipalViewServlet")
public class PrincipalViewServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin_principals.jsp?error=Missing id");
            return;
        }
        int id;
        try { id = Integer.parseInt(idStr); } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin_principals.jsp?error=Invalid id");
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT id, school_name, principal_name, email, phone_number, service_period, employee_number, school_address, approved, created_at, approved_at, rejected_at, rejection_reason FROM principals WHERE id = ?")) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    response.sendRedirect(request.getContextPath() + "/admin_principals.jsp?error=Not found");
                    return;
                }

                request.setAttribute("id", rs.getInt("id"));
                request.setAttribute("school_name", rs.getString("school_name"));
                request.setAttribute("principal_name", rs.getString("principal_name"));
                request.setAttribute("email", rs.getString("email"));
                request.setAttribute("phone_number", rs.getString("phone_number"));
                request.setAttribute("service_period", rs.getString("service_period"));
                request.setAttribute("employee_number", rs.getString("employee_number"));
                request.setAttribute("school_address", rs.getString("school_address"));
                request.setAttribute("approved", rs.getBoolean("approved"));
                request.setAttribute("created_at", rs.getTimestamp("created_at"));
                request.setAttribute("approved_at", rs.getTimestamp("approved_at"));
                request.setAttribute("rejected_at", rs.getTimestamp("rejected_at"));
                request.setAttribute("rejection_reason", rs.getString("rejection_reason"));
            }

            // forward to JSP
            request.getRequestDispatcher("/principal_view.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
