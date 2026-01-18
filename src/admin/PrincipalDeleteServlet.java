package admin;

import com.example.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/PrincipalDeleteServlet")
public class PrincipalDeleteServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            if (session != null) session.setAttribute("error", "Not authorized.");
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null) {
            session.setAttribute("error", "Missing principal id.");
            resp.sendRedirect(req.getContextPath() + "/admin_dashboard.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            int id = Integer.parseInt(idStr);

            // Delete any needs created by this principal
            String deleteNeeds = "DELETE FROM school_requests WHERE principal_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteNeeds)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            // Delete principal account
            String delSql = "DELETE FROM principals WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(delSql)) {
                ps.setInt(1, id);
                int rows = ps.executeUpdate();

                if (rows == 0) {
                    session.setAttribute("error", "Principal not found.");
                } else {
                    session.setAttribute("success", "Principal deleted successfully.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error deleting principal: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin_dashboard.jsp");
    }
}
