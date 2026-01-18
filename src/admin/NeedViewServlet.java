package admin;

import com.example.db.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class NeedViewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/school_needs.jsp");
            return;
        }

        int needId;
        try {
            needId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/school_needs.jsp");
            return;
        }

        Map<String, Object> need = new HashMap<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT * FROM school_requests WHERE id = ?")) {

            ps.setInt(1, needId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    need.put("id", rs.getInt("id"));
                    need.put("school_name", rs.getString("school_name"));
                    need.put("title", rs.getString("title"));
                    need.put("description", rs.getString("description"));
                    need.put("quantity", rs.getInt("quantity"));
                    need.put("status", rs.getString("status"));
                    need.put("created_at", rs.getTimestamp("created_at"));
                } else {
                    response.sendRedirect(request.getContextPath() + "/school_needs.jsp");
                    return;
                }
            }

            request.setAttribute("need", need);
            request.getRequestDispatcher("/admin/need_view.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/school_needs.jsp");
        }
    }
}
