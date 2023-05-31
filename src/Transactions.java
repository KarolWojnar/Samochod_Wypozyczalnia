import org.jdatepicker.JDatePicker;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;
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
    public static int index = -1;
    private int koszt;

    public static void main(String[] args) {
        new Transactions().setVisible(true);
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
                index = car.getSelectedIndex();

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
                    days = (int) ((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24));
                    today = (int) ((startDate.getTime() - todayDate.getTime()) / (1000 * 60 * 60 * 24));
                } catch (ParseException e) {
                    throw new RuntimeException(e);
                }
                if (days <= 0) JOptionPane.showMessageDialog(null, "Podaj prawidłową datę");
                else if (today < 0) JOptionPane.showMessageDialog(null, "Podaj prawidłową datę");
                else {

                    int choice = JOptionPane.showConfirmDialog(null, "Czy taka cena Ci odpowiada: " + returnPrice(View.name, ubezp, startDateString, endDateString) + "?", "Cena", JOptionPane.YES_NO_OPTION);

                    if (choice == 0) {
                        conn = ConnectorDbase.mycon();
                        try {
                            String sqlProc = "{CALL DodajWypozyczenie(?, ?, ?, ?, ?, ?)}";
                            CallableStatement statement = conn.prepareCall(sqlProc);
                            statement.setInt(1, View.idKilent);
                            statement.setInt(2, tabOfId[index]);
                            statement.setDate(3, java.sql.Date.valueOf(startDateString));
                            statement.setDate(4, java.sql.Date.valueOf(endDateString));
                            statement.setInt(5, koszt);
                            statement.setString(6, ubezp);
                            statement.execute();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                        dispose();
                        new Bye().setVisible(true);
                    }
                }
            }
        });
    }

    public int returnPrice(String name, String ubez, String start, String end)
    {
        try {
            String callProcedure = "{CALL ObliczKosztWypozyczenia(?, ?, ?, ?, ?)}";
            CallableStatement statement = conn.prepareCall(callProcedure);
            statement.setString(1, name);
            statement.setString(2, ubez);
            statement.setDate(3, java.sql.Date.valueOf(start));
            statement.setDate(4, java.sql.Date.valueOf(end));
            statement.registerOutParameter(5, Types.NUMERIC);
            statement.execute();
            koszt = statement.getInt(5);
            System.out.println("Koszt wypożyczenia: " + koszt);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return koszt;
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
/*
        Procedura obliczająca cenę wypozyczenia:

        DELIMITER //

CREATE PROCEDURE ObliczKosztWypozyczenia(IN Klasa VARCHAR(1), IN typ_ubezpieczenia VARCHAR(25),
                                         IN data_wypożyczenia DATE, IN data_zwrotu DATE, OUT koszt DECIMAL(10, 2))
BEGIN
    DECLARE cena_samochodu DECIMAL(10, 2);
    DECLARE cena_ubezpieczenia DECIMAL(10, 2);
    DECLARE ilosc_dni INT;

    SELECT
        CASE Klasa
            WHEN 'a' THEN 160
            WHEN 'b' THEN 120
            WHEN 'c' THEN 90
            WHEN 'd' THEN 75
            ELSE 0
        END INTO cena_samochodu;

    SELECT
        CASE typ_ubezpieczenia
            WHEN 'brak' THEN 1
            WHEN 'od szkód własnych' THEN 1.3
            WHEN 'od kradzieży' THEN 1.3
            WHEN 'całkowite' THEN 1.5
            ELSE 0
        END INTO cena_ubezpieczenia;

    SET ilosc_dni = DATEDIFF(data_zwrotu, data_wypozyczenia);

    SET koszt = cena_samochodu * ilosc_dni * cena_ubezpieczenia;
END //
DELIMITER ;

 */



/*
    Procedura dodająca rekrdy do wypożyczenia jesli klient zdecyduje sie na wypożyczenie i zmienia dostepność w tabeli samochody


        DELIMITER //

CREATE PROCEDURE DodajWypozyczenie(IN p_klient_id INT(11), IN p_samochod_id INT(11), IN p_data_wypozyczenia DATE, IN p_data_zwrotu DATE,
                             	   IN p_koszt INT(8), IN p_typ_ubezpiecznia VARCHAR(25))
BEGIN
    DECLARE s_wypozyczenia_id INT;

    SET @losowa_wartosc := FLOOR(RAND() * 10) + 1;

    SELECT MAX(wypożyczenia_id)+1 INTO s_wypozyczenia_id FROM wypożyczenia;

    INSERT INTO wypożyczenia (wypożyczenia_id, klient_id, samochód_id, Data_wypożyczenia, Data_zwrotu, Koszt, typ_ubezpieczenia, przydzielony_pracownik_id )
   	VALUES  (s_wypozyczenia_id, p_klient_id, p_samochod_id, p_data_wypozyczenia, p_data_zwrotu, p_koszt, p_typ_ubezpiecznia, @losowa_wartosc);

	UPDATE samochód SET dostepnosc="wypozyczony" where Samochód_id=p_samochod_id;

END //

DELIMITER ;
 */