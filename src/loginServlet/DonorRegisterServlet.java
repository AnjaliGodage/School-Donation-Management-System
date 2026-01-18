package loginServlet;

import com.example.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DonorRegisterServlet")
public class DonorRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String firstName = request.getParameter("firstName").trim();
        String lastName  = request.getParameter("lastName").trim();
        String dob       = request.getParameter("dob");
        String address   = request.getParameter("address").trim();
        String phone     = request.getParameter("phone").trim();
        String email     = request.getParameter("email").trim();
        String username  = request.getParameter("username").trim();
        String password  = request.getParameter("password"); // in production, hash the password

        // basic server-side validation
        if (firstName.isEmpty() || lastName.isEmpty() || dob == null || dob.isEmpty()
                || address.isEmpty() || phone.isEmpty() || email.isEmpty()
                || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Please fill all required fields.");
            request.getRequestDispatcher("/donor_register.jsp").forward(request, response);
            return;
        }

        String sql = "INSERT INTO donors (first_name,last_name,dob,address,phone,email,username,password) VALUES (?,?,?,?,?,?,?,?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, firstName);
            ps.setString(2, lastName);
            // convert yyyy-mm-dd string to java.sql.Date
            ps.setDate(3, Date.valueOf(dob));
            ps.setString(4, address);
            ps.setString(5, phone);
            ps.setString(6, email);
            ps.setString(7, username);
            ps.setString(8, password); // hash in production
            ps.executeUpdate();

            // after successful registration -> redirect to donor login page
            response.sendRedirect(request.getContextPath() + "/donor_login.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            String msg = e.getMessage() == null ? "" : e.getMessage().toLowerCase();
            if (msg.contains("duplicate") || msg.contains("unique")) {
                request.setAttribute("errorMessage", "Username or email already exists.");
            } else {
                request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
            }
            request.getRequestDispatcher("/donor_register.jsp").forward(request, response);
        }
    }
}
