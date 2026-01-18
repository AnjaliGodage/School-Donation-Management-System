package admin;

import com.example.db.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin/donors")
public class DonorListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String,Object>> donors = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM donors")) {

            while (rs.next()) {
                Map<String,Object> donor = new HashMap<>();
                donor.put("id", rs.getInt("id"));
                donor.put("first_name", rs.getString("first_name"));
                donor.put("last_name", rs.getString("last_name"));
                donor.put("email", rs.getString("email"));
                donor.put("phone", rs.getString("phone"));
                donor.put("username", rs.getString("username"));
                donors.add(donor);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        // Forward to JSP outside admin folder
        request.setAttribute("donors", donors);
        request.getRequestDispatcher("/donors.jsp").forward(request, response);
    }
}
