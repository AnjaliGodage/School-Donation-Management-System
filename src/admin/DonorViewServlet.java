package admin;

import com.example.db.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/donor/view")
public class DonorViewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/donors");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Map<String,Object> donor = null;

            String sql = "SELECT * FROM donors WHERE id=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        donor = new HashMap<>();
                        donor.put("id", rs.getInt("id"));
                        donor.put("first_name", rs.getString("first_name"));
                        donor.put("last_name", rs.getString("last_name"));
                        donor.put("dob", rs.getDate("dob"));
                        donor.put("address", rs.getString("address"));
                        donor.put("phone", rs.getString("phone"));
                        donor.put("email", rs.getString("email"));
                        donor.put("username", rs.getString("username"));
                        donor.put("created_at", rs.getTimestamp("created_at"));
                    }
                }
            }

            request.setAttribute("donor", donor);
            request.getRequestDispatcher("/view_donor.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException e) {
            response.sendRedirect(request.getContextPath() + "/admin/donors");
        }
    }
}
