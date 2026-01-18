package admin;

import com.example.db.DBConnection;
import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PrincipalRegisterServlet")
@MultipartConfig
public class PrincipalRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String schoolName = request.getParameter("school_name");
        String principalName = request.getParameter("principal_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone_number");
        int servicePeriod = Integer.parseInt(request.getParameter("service_period"));
        String empNumber = request.getParameter("employee_number");
        String schoolAddress = request.getParameter("school_address");
        Part proof = request.getPart("proof_document");
        byte[] proofBytes = proof.getInputStream().readAllBytes();

        try(Connection conn = DBConnection.getConnection()){
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO principals (school_name, principal_name, email, phone_number, service_period, employee_number, school_address, proof_document) VALUES (?,?,?,?,?,?,?,?)"
            );
            ps.setString(1, schoolName);
            ps.setString(2, principalName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setInt(5, servicePeriod);
            ps.setString(6, empNumber);
            ps.setString(7, schoolAddress);
            ps.setBytes(8, proofBytes);

            int inserted = ps.executeUpdate();
            if(inserted > 0){
                request.setAttribute("success", "Registration successful. Wait for approval.");
                request.getRequestDispatcher("principal_register.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed.");
                request.getRequestDispatcher("principal_register.jsp").forward(request, response);
            }

        } catch(Exception e){
            e.printStackTrace();
            request.setAttribute("error", "Server error: "+ e.getMessage());
            request.getRequestDispatcher("principal_register.jsp").forward(request, response);
        }
    }
}
