package admin;

import com.example.db.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class NeedEditServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM school_requests WHERE id=?")) {

            ps.setInt(1, Integer.parseInt(idStr));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("need", rs);
                request.getRequestDispatcher("/admin_need_edit.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String status = request.getParameter("status");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE school_requests SET title=?, description=?, quantity=?, status=? WHERE id=?")) {

            ps.setString(1, title);
            ps.setString(2, description);
            ps.setInt(3, quantity);
            ps.setString(4, status);
            ps.setInt(5, id);

            ps.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
