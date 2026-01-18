package admin;

import com.example.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/SchoolNeedDeleteServlet")
public class SchoolNeedDeleteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);

                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps =
                         conn.prepareStatement("DELETE FROM school_requests WHERE id = ?")) {

                    ps.setInt(1, id);
                    ps.executeUpdate();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Redirect back to admin page
        response.sendRedirect(request.getContextPath() + "/school_needs.jsp");
    }
}
