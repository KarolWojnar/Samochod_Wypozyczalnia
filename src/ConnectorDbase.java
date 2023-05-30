//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectorDbase {
    public static Connection mycon() {
        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/wypozyczalnia", "root", "");
        } catch (SQLException | ClassNotFoundException var2) {
            System.out.println(var2);
        }
        return con;
    }
}
