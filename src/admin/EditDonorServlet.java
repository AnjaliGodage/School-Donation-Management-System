package admin;

import com.example.db.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin/donor/edit")
public class EditDonorServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if(idStr == null){
            response.sendRedirect(request.getContextPath() + "/admin/donors");
            return;
        }

        int id = Integer.parseInt(idStr);

        try(Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM donors WHERE id=?")) {
            ps.setInt(1,id);
            try(ResultSet rs = ps.executeQuery()){
                if(rs.next()){
                    request.setAttribute("id", rs.getInt("id"));
                    request.setAttribute("first_name", rs.getString("first_name"));
                    request.setAttribute("last_name", rs.getString("last_name"));
                    request.setAttribute("email", rs.getString("email"));
                    request.setAttribute("phone", rs.getString("phone"));
                    request.setAttribute("username", rs.getString("username"));
                    request.setAttribute("dob", rs.getDate("dob"));
                    request.setAttribute("address", rs.getString("address"));
                }
            }
        } catch(SQLException e){ e.printStackTrace(); }

        request.getRequestDispatcher("/admin/edit_donor.jsp").forward(request,response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String first_name = request.getParameter("first_name");
        String last_name = request.getParameter("last_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String address = request.getParameter("address");

        try(Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE donors SET first_name=?, last_name=?, email=?, phone=?, username=?, address=? WHERE id=?")) {

            ps.setString(1, first_name);
            ps.setString(2, last_name);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, username);
            ps.setString(6, address);
            ps.setInt(7, id);

            ps.executeUpdate();

        } catch(SQLException e){ e.printStackTrace(); }

        response.sendRedirect(request.getContextPath() + "/admin/donors");
    }
}
