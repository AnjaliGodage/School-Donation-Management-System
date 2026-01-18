package adminServlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Hardcoded admin credentials (replace with DB later)
    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PASSWORD = "admin123";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && "admin".equals(session.getAttribute("role"))) {
            // Already logged in → redirect to admin dashboard
            response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
            return;
        }

        // Show admin login page
        request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
            return;
        }

        if (ADMIN_USERNAME.equals(username) && ADMIN_PASSWORD.equals(password)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("username", username);
            session.setAttribute("role", "admin");
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
        } else {
            request.setAttribute("errorMessage", "Invalid admin credentials.");
            request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
        }
    }
}
