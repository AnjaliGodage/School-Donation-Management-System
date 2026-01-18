package admin;

import com.example.db.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class NeedDeleteServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if(idStr != null){
            int id = Integer.parseInt(idStr);
            try(Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("DELETE FROM school_requests WHERE id=?")){
                ps.setInt(1,id);
                ps.executeUpdate();
            }catch(Exception e){ e.printStackTrace();}
        }
        response.sendRedirect("school_needs.jsp");
    }
}
