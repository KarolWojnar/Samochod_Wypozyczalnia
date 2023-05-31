import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class View extends JFrame{
    private JPanel main1;
    private JButton A;
    private JButton B;
    private JButton C;
    private JButton Toyota;
    private JButton D;
    private JPanel panel1;
    private JPanel panel2;
    public static int[] listOfClass = new int[50];
    private JLabel asd;
    private JPanel rPanel;
    private JPanel lPanel;
    private JTextField dataUrTF;
    private JTextField imieTF;
    private JTextField nazwiskoTF;
    private JTextField numerTF;
    private JTextField adresTF;
    private JTextField wojeTF;
    private JTextField miastoTF;
    private JTextField kodPTF;
    String imie = null;
    String nazwisko = null;
    String data_ur = null;
    String nr_tel = null;
    String adres = null;
    String woje = null;
    String miasto = null;
    String kod_pocz = null;
    private JPanel formPanel;
    public static String name = null;
    private Connection con = null;
    private ResultSet rs = null;
    int idKilent;
    public static int w = (int) Toolkit.getDefaultToolkit().getScreenSize().getWidth();
    public static int h = (int) Toolkit.getDefaultToolkit().getScreenSize().getHeight();
    public static void main(String[] args) {
        new View().setVisible(true);
    }

    View(){
        super("essa");
        this.setDefaultCloseOperation(3);
        this.setSize(new Dimension(w, h));
        this.setLayout(new GridLayout(1, 2));
        rPanel.setLayout(new GridLayout(2,1));
        rPanel.add(panel1);
        rPanel.add(panel2);
        this.getContentPane().add(lPanel);
        this.getContentPane().add(main1);
        panel1.setBackground(Color.gray);
        asd.setForeground(Color.white);
        panel2.setBackground(Color.gray);
        ActionListener listener = new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent actionEvent) {
                imie = imieTF.getText();
                nazwisko = nazwiskoTF.getText();
                data_ur = dataUrTF.getText();
                nr_tel = numerTF.getText();
                adres = adresTF.getText();
                woje = wojeTF.getText();
                miasto = miastoTF.getText();
                kod_pocz = kodPTF.getText();
                if((!imie.isEmpty()) && (!nazwisko.isEmpty()) && (!data_ur.isEmpty()) && (!nr_tel.isEmpty()) && (!adres.isEmpty()) && (!woje.isEmpty()) && (!miasto.isEmpty()) && (!kod_pocz.isEmpty()))
                {
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
                    CheckIfExist(imie, nazwisko, data_ur, nr_tel, adres, woje, miasto, kod_pocz);
                    new Transactions().setVisible(true);
                    dispose();
                }
                else JOptionPane.showMessageDialog(null, "Podaj wszystkie dane!");
            }
        };
        A.addActionListener(listener);
        B.addActionListener(listener);
        C.addActionListener(listener);
        D.addActionListener(listener);
    }

    public void CheckIfExist(String imie, String naziwsko, String data_ur, String nr, String adres, String woje, String miasto, String kodP)
    {
        con = ConnectorDbase.mycon();
        try {
            String sql = "select k.Klient_id from klient k INNER JOIN adres a ON k.Adres_id = a.Adres_id WHERE k.Imie = '" + imie + "' AND k.Nazwisko = '" + naziwsko + "' AND k.Data_urodzenia = '" + data_ur + "' AND k.Nr_telefonu = '" + nr + "' AND " +
                    "a.Adres = '" + adres + "' AND a.Województwo = '" + woje + "' AND a.Miasto = '" + miasto + "' AND  a.Kod_pocztowy= '" + kodP + "'";
            rs = con.prepareStatement(sql).executeQuery();
            if(rs.next()){
                idKilent = rs.getInt("Klient_id");
            }
            else{
            }

        }catch (SQLException e){
            JOptionPane.showMessageDialog(null, e);
        }
    }


}
