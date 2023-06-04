import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Bye extends JFrame{
    private JPanel panel1;
    private JLabel gratulacje;
    private String pracownikImie;
    private int pracownikNumer;
    private String markaSam;
    private String modelSam;
    private JButton zamknijButton;
    private JLabel pracownik;
    private Connection con = null;
    private ResultSet rs = null;
    private int w = Toolkit.getDefaultToolkit().getScreenSize().width;
    private int h = Toolkit.getDefaultToolkit().getScreenSize().height;

    public static void main(String[] args) {
        new Bye().setVisible(true);
    }
    Bye() {
        this.setTitle("Gratulacje");
        this.setDefaultCloseOperation(3);
        this.setBounds(w/4 , h/3,w/2, h/4);
        this.getContentPane().add(panel1);

        getPracownik();
        gratulacje.setText("Gratulacje " + View.imie + ", Twoje auto to: " + markaSam + " " + modelSam);
        pracownik.setText("Pracownik obsługujuący Twoje wypożyczenie to: " + pracownikImie + " a jego numer to: " + pracownikNumer);

        zamknijButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent actionEvent) {
                dispose();
            }
        });
    }
    void getPracownik()
    {
        con = ConnectorDbase.mycon();
        int i = 0;
        try {
            String sql = "SELECT p.imie, p.nr_tel, s.Marka, s.Model FROM " +
                    "wypożyczenia w JOIN pracownicy p ON w.przydzielony_pracownik_id = p.przydzielony_pracownik_id JOIN " +
                    "samochód s ON w.Samochód_id = s.Samochód_id WHERE " +
                    "w.Wypożyczenia_id = (SELECT MAX(Wypożyczenia_id) FROM wypożyczenia);";
            rs = con.prepareStatement(sql).executeQuery();
            if(rs.next()){
                pracownikImie = rs.getString("imie");
                pracownikNumer = rs.getInt("nr_tel");
                markaSam = rs.getString("Marka");
                modelSam = rs.getString("Model");
            }

        }catch (SQLException e){
            JOptionPane.showMessageDialog(null, e);
        }
    }
}


