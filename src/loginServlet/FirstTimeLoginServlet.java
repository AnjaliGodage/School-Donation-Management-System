package loginServlet;

import com.example.db.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/FirstTimeLoginServlet")
public class FirstTimeLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String empNumber = request.getParameter("employee_number");
        String newPass = request.getParameter("new_password");
        String confirmPass = request.getParameter("confirm_password");

        if (!newPass.equals(confirmPass)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("first_time_setup.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement ps = conn.prepareStatement(
                "SELECT id, approved, rejected, password FROM principals WHERE employee_number=?"
            );
            ps.setString(1, empNumber);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                request.setAttribute("error", "Employee number not found.");
                request.getRequestDispatcher("first_time_setup.jsp").forward(request, response);
                return;
            }

            boolean approved = rs.getBoolean("approved");
            boolean rejected = rs.getBoolean("rejected");
            String dbPassword = rs.getString("password");
            int principalId = rs.getInt("id");

            if (rejected) {
                request.setAttribute("error", "Your account has been rejected. Cannot set password.");
                request.getRequestDispatcher("principal_login.jsp").forward(request, response);
                return;
            }

            if (!approved) {
                request.setAttribute("error", "Your account is pending approval. Cannot set password yet.");
                request.getRequestDispatcher("principal_login.jsp").forward(request, response);
                return;
            }

            if (dbPassword != null && !dbPassword.trim().isEmpty()) {
                request.setAttribute("error", "Password already set. Please login.");
                request.getRequestDispatcher("principal_login.jsp").forward(request, response);
                return;
            }

            PreparedStatement update = conn.prepareStatement(
                "UPDATE principals SET password=? WHERE id=?"
            );
            update.setString(1, newPass); // you can hash here if you want
            update.setInt(2, principalId);
            update.executeUpdate();

            request.setAttribute("success", "Password set successfully. Please login.");
            request.getRequestDispatcher("principal_login.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error.");
            request.getRequestDispatcher("first_time_setup.jsp").forward(request, response);
        }
    }
}
