package admin;

import com.example.db.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminPrincipalsServlet")
public class AdminPrincipalsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT id, school_name, principal_name, email, service_period, employee_number, school_address, approved, created_at " +
                     "FROM principals ORDER BY created_at DESC")) {

            ResultSet rs = ps.executeQuery();
            request.setAttribute("principalsRs", rs);
            request.getRequestDispatcher("/admin_principals.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin_principals.jsp").forward(request, response);
        }
    }
}
