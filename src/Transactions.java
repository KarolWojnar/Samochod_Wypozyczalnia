import org.jdatepicker.JDatePicker;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDate;
import java.time.Period;
import java.time.temporal.ChronoUnit;
import java.time.temporal.Temporal;
import java.util.Calendar;
import java.util.Date;

public class Transactions extends JFrame {
    private JPanel panel1;
    private JPanel samochod;
    private JPanel ubezpieczenie;
    private JPanel cena;
    private JButton confirm;
    private JLabel price;
    private JLabel startLabel = new JLabel("Wybież datę rozpoczęcia wypożyczenia");
    private JLabel endLabel = new JLabel("Wybież datę końca wypożyczenia");
    private JComboBox car;
    private JComboBox ubez;
    private JPanel okres;
    JDatePicker datePicker1 = new JDatePicker();
    JDatePicker datePicker2 = new JDatePicker();
    public static int w = (int) Toolkit.getDefaultToolkit().getScreenSize().getWidth();
    public static int h = (int) Toolkit.getDefaultToolkit().getScreenSize().getHeight();
    private Connection conn = null;
    private ResultSet rs = null;
    int i = 0;
    int[] tabOfId = new int[50];

    public static void main(String[] args) {
    }

    Transactions() {
        this.setTitle("Options");
        this.setDefaultCloseOperation(3);
        this.setSize(w, h);
        this.getContentPane().add(panel1);
        okres.setLayout(new GridLayout(2, 2));
        okres.add(startLabel);
        okres.add(endLabel);
        okres.setMaximumSize(new Dimension(40, 40));
        okres.add(datePicker1);
        okres.add(datePicker2);
        getCars();
        confirm.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent actionEvent) {
                int index = car.getSelectedIndex();
                String ubezp = ubez.getSelectedItem().toString();
                String startDateString = datePicker1.getModel().getYear() + "-" + (datePicker1.getModel().getMonth() + 1) + "-" + datePicker1.getModel().getDay();
                String endDateString = datePicker2.getModel().getYear() + "-" + (datePicker2.getModel().getMonth() + 1) + "-" + datePicker2.getModel().getDay();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Calendar calendar = Calendar.getInstance();
                Date startDate;
                Date endDate;
                Date todayDate = calendar.getTime();
                int days = 0;
                int today = 0;
                try {
                    startDate = sdf.parse(startDateString);
                    endDate = sdf.parse(endDateString);
                    days = (int) ((endDate.getTime() - startDate.getTime())/(1000 * 60 * 60 * 24));
                    today = (int) ((startDate.getTime() - todayDate.getTime())/(1000 * 60 * 60 * 24));
                    System.out.println(tabOfId[index] + " " + ubezp + " " + startDate + " " + endDate + " roznica: " + days + " || " + today);
                } catch (ParseException e) {
                    throw new RuntimeException(e);
                }
                if(days <= 0) JOptionPane.showMessageDialog(null, "Podaj prawidłową datę1");
                else if(today < 0) JOptionPane.showMessageDialog(null, "Podaj prawidłową datę2");
                else {

                }

            }
        });
    }

    public void getCars() {
        conn = ConnectorDbase.mycon();
        try {
            String sql = "SELECT s.Samochód_id, s.Marka, s.Model, s.Liczba_drzwi, s.Ilość_miejsc, s.Rok_produkcji, i.pojemnosc_bagaznika, " +
                    "i.skrzynia_biegow, i.Pojemność_silnika, i.Moc_silnika, w.nazwa, w.adres " +
                    "FROM samochód s " +
                    "INNER JOIN info_techniczne i ON s.Info_techniczne_id = i.Info_techniczne_id " +
                    "INNER JOIN wypozyczalnia w ON s.wypozyczalnia_id = w.wypozyczalnia_id " +
                    "WHERE s.dostepnosc = 'dostepny' and s.Klasa = '" + View.name + "'" +
                    "order by s.samochód_id";
            rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) {
                        tabOfId[i++] = rs.getInt("Samochód_id");
                        car.addItem(rs.getString("Marka")
                        + ", " + rs.getString("Model")
                        + " | " + rs.getString("Liczba_drzwi")
                        + " | " + rs.getString("Ilość_miejsc")
                        + " | " + rs.getString("Rok_produkcji")
                        + " | " + rs.getString("pojemnosc_bagaznika")
                        + " | " + rs.getString("skrzynia_biegow")
                        + " | " + rs.getString("Pojemność_silnika")
                        + " | " + rs.getString("Moc_silnika")
                        + " | " + rs.getString("nazwa")
                        + ", " + rs.getString("adres")
                );
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, e);
        }

    }
}
