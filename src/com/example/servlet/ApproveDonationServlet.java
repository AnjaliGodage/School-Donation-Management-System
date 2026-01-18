package com.example.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.example.db.DBConnection;

@WebServlet("/ApproveDonationServlet")
public class ApproveDonationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DBConnection.getConnection()) {

            // Get request details (title)
            PreparedStatement ps = conn.prepareStatement(
                "SELECT title FROM school_requests WHERE id=?"
            );
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String title = rs.getString("title");

                // APPROVE
                if ("approve".equals(action)) {
                    PreparedStatement ps2 = conn.prepareStatement(
                        "UPDATE school_requests SET status='approved' WHERE id=?"
                    );
                    ps2.setInt(1, id);
                    ps2.executeUpdate();

                // REJECT
                } else if ("reject".equals(action)) {
                    PreparedStatement ps2 = conn.prepareStatement(
                        "UPDATE school_requests SET status='rejected' WHERE id=?"
                    );
                    ps2.setInt(1, id);
                    ps2.executeUpdate();
                }
            }

            response.sendRedirect("approve_donations.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("approve_donations.jsp");
        }
    }
}
