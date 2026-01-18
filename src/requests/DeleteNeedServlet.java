package requests;

import com.example.db.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.File;
import java.io.IOException;
import java.sql.*;

@WebServlet("/DeleteNeedServlet")
public class DeleteNeedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String idParam = request.getParameter("id");
        if (idParam == null) {
            session.setAttribute("error", "Missing request id.");
            response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
            return;
        }

        int needId;
        try { needId = Integer.parseInt(idParam); } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid request id.");
            response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
            return;
        }

        String filePath = null;
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("SELECT file_path FROM school_requests WHERE id = ?")) {
                ps.setInt(1, needId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) filePath = rs.getString("file_path");
                }
            }

            try (PreparedStatement psDel = conn.prepareStatement("DELETE FROM school_requests WHERE id = ?")) {
                psDel.setInt(1, needId);
                int affected = psDel.executeUpdate();
                if (affected > 0) {
                    if (filePath != null && !filePath.isEmpty()) {
                        File f = new File(getServletContext().getRealPath("/") + File.separator + filePath);
                        if (f.exists()) f.delete();
                    }
                    session.setAttribute("success", "Request deleted.");
                } else {
                    session.setAttribute("error", "Request not found.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "DB error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
    }
}
