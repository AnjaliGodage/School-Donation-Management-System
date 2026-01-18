package loginServlet;

import com.example.db.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/PrincipalFirstTimeLoginServlet")
public class PrincipalFirstTimeLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String empNo = request.getParameter("employee_number");
        String pass = request.getParameter("new_password");
        String confirm = request.getParameter("confirm_password");

        if(empNo == null || pass == null || confirm == null || !pass.equals(confirm)){
            request.setAttribute("error","Passwords do not match.");
            request.getRequestDispatcher("first_time_setup.jsp").forward(request,response);
            return;
        }

        try(Connection conn = DBConnection.getConnection()){
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE principals SET password=? WHERE employee_number=? AND password IS NULL"
            );
            ps.setString(1, pass);
            ps.setString(2, empNo);
            int updated = ps.executeUpdate();

            if(updated > 0){
                request.setAttribute("success","Password set successfully. Please login.");
            } else {
                request.setAttribute("error","Employee Number invalid or password already set.");
            }

            request.getRequestDispatcher("first_time_setup.jsp").forward(request,response);
        } catch(SQLException e){
            e.printStackTrace();
            request.setAttribute("error","Database error: "+e.getMessage());
            request.getRequestDispatcher("first_time_setup.jsp").forward(request,response);
        }
    }
}
