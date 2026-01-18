package requests;

import com.example.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.*;
import java.util.UUID;

@WebServlet("/AddNeedServlet")
@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 1024*1024*10, maxRequestSize = 1024*1024*20)
public class AddNeedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);

        Integer principalId = (Integer) session.getAttribute("principalId");
        if (principalId == null) {
            String pid = request.getParameter("principalId");
            if (pid != null) {
                try { principalId = Integer.parseInt(pid); } catch (NumberFormatException ignored) {}
            }
        }
        if (principalId == null) {
            session.setAttribute("error", "Please login and try again.");
            response.sendRedirect(request.getContextPath() + "/principal_login.jsp");
            return;
        }

        String title = trim(request.getParameter("title"));
        String category = trim(request.getParameter("category"));
        String description = trim(request.getParameter("description"));
        String amountStr = trim(request.getParameter("amount_needed"));
        String deadlineStr = trim(request.getParameter("deadline"));
        String accountNumber = trim(request.getParameter("account_number"));

        if (title == null || title.isEmpty()) {
            session.setAttribute("error", "Title is required.");
            response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
            return;
        }
        if (description == null || description.isEmpty()) {
            session.setAttribute("error", "Description is required.");
            response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
            return;
        }
        if (category == null || category.isEmpty()) category = "Other";

        BigDecimal amount = null;
        if (amountStr != null && !amountStr.isEmpty()) {
            try { amount = new BigDecimal(amountStr); if (amount.compareTo(BigDecimal.ZERO) < 0) throw new NumberFormatException(); }
            catch (NumberFormatException ex) {
                session.setAttribute("error", "Invalid amount format.");
                response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
                return;
            }
        }

        java.sql.Date deadline = null;
        if (deadlineStr != null && !deadlineStr.isEmpty()) {
            try { deadline = java.sql.Date.valueOf(deadlineStr); }
            catch (IllegalArgumentException ex) {
                session.setAttribute("error", "Invalid deadline date.");
                response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
                return;
            }
        }

        // handle file part
        Part filePart = request.getPart("attachment");
        String storedRelativePath = null;
        if (filePart != null && filePart.getSize() > 0) {
            String submitted = filePart.getSubmittedFileName();
            String base = new File(submitted).getName();
            String cleaned = base.replaceAll("[^a-zA-Z0-9._-]", "_");
            String ext = "";
            int dot = cleaned.lastIndexOf('.');
            if (dot > 0) ext = cleaned.substring(dot);
            String unique = System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0,8) + ext;

            String uploadsPath = getServletContext().getRealPath("/") + File.separator + UPLOAD_DIR;
            File uploadsDir = new File(uploadsPath);
            if (!uploadsDir.exists()) uploadsDir.mkdirs();

            File outFile = new File(uploadsDir, unique);
            try (InputStream in = filePart.getInputStream()) {
                Files.copy(in, outFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                storedRelativePath = UPLOAD_DIR + "/" + unique;
            } catch (IOException ex) {
                ex.printStackTrace();
                session.setAttribute("error", "Failed to save attachment: " + ex.getMessage());
                response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
                return;
            }
        }

        String sql = "INSERT INTO school_requests (principal_id, title, category, description, amount_needed, deadline, status, file_path, account_number) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, principalId);
            ps.setString(2, title);
            ps.setString(3, category);
            ps.setString(4, description);

            if (amount != null) ps.setBigDecimal(5, amount);
            else ps.setNull(5, Types.DECIMAL);

            if (deadline != null) ps.setDate(6, deadline);
            else ps.setNull(6, Types.DATE);

            ps.setString(7, "open");

            if (storedRelativePath != null) ps.setString(8, storedRelativePath);
            else ps.setNull(8, Types.VARCHAR);

            if (accountNumber != null && !accountNumber.isEmpty()) ps.setString(9, accountNumber);
            else ps.setNull(9, Types.VARCHAR);

            int inserted = ps.executeUpdate();
            if (inserted > 0) session.setAttribute("success", "Request created successfully.");
            else session.setAttribute("error", "Failed to create request.");

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Database error: " + e.getMessage());
            if (storedRelativePath != null) {
                File f = new File(getServletContext().getRealPath("/") + File.separator + storedRelativePath);
                if (f.exists()) f.delete();
            }
        }

        response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
    }

    private String trim(String s) { return s == null ? null : s.trim(); }
}
