package admin;

import com.example.db.DBConnection;
import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DownloadFile") // unique URL
public class DownloadDocument extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.getWriter().println("No ID provided.");
            return;
        }

        int id = Integer.parseInt(idStr);
        boolean inline = "true".equals(request.getParameter("inline"));

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT proof_document FROM principals WHERE id=?")) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (!rs.next() || rs.getBlob("proof_document") == null) {
                response.getWriter().println("No document found.");
                return;
            }

            Blob blob = rs.getBlob("proof_document");
            byte[] bytes = blob.getBytes(1, (int) blob.length());

            String mimeType = getServletContext().getMimeType("document.pdf");
            if (mimeType == null) mimeType = "application/octet-stream";

            response.setContentType(mimeType);
            if (inline) {
                response.setHeader("Content-Disposition", "inline; filename=document_" + id + ".pdf");
            } else {
                response.setHeader("Content-Disposition", "attachment; filename=document_" + id + ".pdf");
            }
            response.setContentLength(bytes.length);

            try (OutputStream out = response.getOutputStream()) {
                out.write(bytes);
            }

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
