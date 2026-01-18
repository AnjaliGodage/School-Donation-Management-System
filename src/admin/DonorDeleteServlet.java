package admin;

import com.example.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/admin/donor/delete")
public class DonorDeleteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/donors");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            String sql = "DELETE FROM donors WHERE id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, id);
                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/admin/donors");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/donors");
        } catch (SQLException e) {
            throw new ServletException("Error deleting donor", e);
        }
    }
}
