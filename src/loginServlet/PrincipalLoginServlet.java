package loginServlet;

import com.example.db.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/PrincipalLoginServlet")
public class PrincipalLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String empNumber = request.getParameter("employee_number");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM principals WHERE employee_number=?"
            );
            ps.setString(1, empNumber);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                request.setAttribute("error", "Employee number not found.");
                request.getRequestDispatcher("principal_login.jsp").forward(request, response);
                return;
            }

            boolean approved = rs.getBoolean("approved");
            boolean rejected = rs.getBoolean("rejected");
            String dbPassword = rs.getString("password");

            if (rejected) {
                request.setAttribute("error", "Your account has been rejected.");
                request.getRequestDispatcher("principal_login.jsp").forward(request, response);
                return;
            }

            if (!approved) {
                request.setAttribute("error", "Your account is pending approval.");
                request.getRequestDispatcher("principal_login.jsp").forward(request, response);
                return;
            }

            // First-time login
            if (dbPassword == null || dbPassword.trim().isEmpty()) {
                request.setAttribute("employee_number", empNumber);
                request.getRequestDispatcher("first_time_setup.jsp").forward(request, response);
                return;
            }

            // Normal login
            if (password.equals(dbPassword)) {
                HttpSession session = request.getSession();
                session.setAttribute("principalId", rs.getInt("id"));
                session.setAttribute("username", rs.getString("principal_name"));
                session.setAttribute("role", "principal");
                response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid credentials.");
                request.getRequestDispatcher("principal_login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error occurred.");
            request.getRequestDispatcher("principal_login.jsp").forward(request, response);
        }
    }
}
