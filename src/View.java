import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

public class View extends JFrame{
    private JPanel main;
    private JButton A;
    private JButton B;
    private JButton C;
    private JButton Toyota;
    private JButton D;
    private JPanel panel1;
    private JPanel panel2;
    public static int[] listOfClass = new int[50];
    private JLabel asd;
    public static String name = null;
    private Connection con = null;
    private ResultSet rs = null;
    public static int w = (int) Toolkit.getDefaultToolkit().getScreenSize().getWidth();
    public static int h = (int) Toolkit.getDefaultToolkit().getScreenSize().getHeight();
    public static void main(String[] args) {
        new View().setVisible(true);
    }

    View(){
        super("essa");
        this.setDefaultCloseOperation(3);
        this.setSize(new Dimension(w, h));
        this.setLayout(new GridLayout(2, 1));
        this.getContentPane().add(panel1);
        this.getContentPane().add(panel2);
        panel1.setBackground(Color.gray);
        asd.setForeground(Color.white);
        panel2.setBackground(Color.gray);
        ActionListener listener = new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent actionEvent) {
                name = actionEvent.getActionCommand();
                con = ConnectorDbase.mycon();
                int i = 0;
                try {
                    String sql = "select Samochód_id from samochód where Klasa = '" + name + "'";
                    rs = con.prepareStatement(sql).executeQuery();
                    while(rs.next()){
                        listOfClass[i++] = rs.getInt("Samochód_id");
                    }

                }catch (SQLException e){
                    JOptionPane.showMessageDialog(null, e);
                }
                new Transactions().setVisible(true);
                dispose();
            }
        };
        A.addActionListener(listener);
        B.addActionListener(listener);
        C.addActionListener(listener);
        D.addActionListener(listener);
    }


}
