-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 31 Maj 2023, 18:55
-- Wersja serwera: 10.4.27-MariaDB
-- Wersja PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `wypozyczalnia`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DodajKlient` (IN `p_adres` VARCHAR(20), IN `p_wojewodztwo` VARCHAR(25), IN `p_miasto` VARCHAR(30), IN `p_kod_pocztowy` VARCHAR(6), IN `p_imie` VARCHAR(20), IN `p_nazwisko` VARCHAR(20), IN `p_data_urodzenia` DATE, IN `p_nr_telefonu` INT(9))   BEGIN 

	DECLARE s_adres_id INT;
    DECLARE s_klient_id INT;
    
	SELECT MAX(adres_id)+1 INTO s_adres_id FROM adres;

	INSERT INTO adres (adres_id, adres, województwo, miasto, kod_pocztowy) VALUES (s_adres_id, p_adres, p_wojewodztwo, p_miasto, p_kod_pocztowy);
    
    SELECT MAX(klient_id)+1 INTO s_klient_id FROM klient;
    
    INSERT INTO klient (klient_id, adres_id, imie, nazwisko, data_urodzenia, nr_telefonu) VALUES (s_klient_id, s_adres_id, p_imie, p_nazwisko, p_data_urodzenia, p_nr_telefonu);
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DodajWypozyczenie` (IN `p_klient_id` INT(11), IN `p_samochod_id` INT(11), IN `p_data_wypozyczenia` DATE, IN `p_data_zwrotu` DATE, IN `p_koszt` INT(8), IN `p_typ_ubezpiecznia` VARCHAR(25))   BEGIN
    DECLARE s_wypozyczenia_id INT;

    SET @losowa_wartosc := FLOOR(RAND() * 10) + 1;

    SELECT MAX(wypożyczenia_id)+1 INTO s_wypozyczenia_id FROM wypożyczenia;

    INSERT INTO wypożyczenia (wypożyczenia_id, klient_id, samochód_id, Data_wypożyczenia, Data_zwrotu, Koszt, typ_ubezpieczenia, przydzielony_pracownik_id )
   	VALUES  (s_wypozyczenia_id, p_klient_id, p_samochod_id, p_data_wypozyczenia, p_data_zwrotu, p_koszt, p_typ_ubezpiecznia, @losowa_wartosc);

	UPDATE samochód SET dostepnosc="wypozyczony" where Samochód_id=p_samochod_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObliczKosztWypozyczenia` (IN `Klasa` VARCHAR(1), IN `typ_ubezpieczenia` VARCHAR(25), IN `data_wypożyczenia` DATE, IN `data_zwrotu` DATE, OUT `koszt` DECIMAL(10,2))   BEGIN
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
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `adres`
--

CREATE TABLE `adres` (
  `Adres_id` int(11) NOT NULL,
  `Adres` varchar(20) DEFAULT NULL,
  `Województwo` varchar(25) DEFAULT NULL,
  `Miasto` varchar(30) DEFAULT NULL,
  `Kod_pocztowy` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Zrzut danych tabeli `adres`
--

INSERT INTO `adres` (`Adres_id`, `Adres`, `Województwo`, `Miasto`, `Kod_pocztowy`) VALUES
(1, 'ulica_Cicha_132', 'Podkarpackie', 'Rzeszów', '36-007'),
(2, 'ulica_Józefa_Bema_54', 'Małopolskie', 'Kraków', '30-001'),
(3, 'ulica_Kawiory_120', 'Małopolskie', 'Kraków', '30-055'),
(4, 'ulica_Kościuszki_26', 'Podkarpackie', 'Sanok', '38-500'),
(5, 'ulica_Solna_2', 'Świętokrzyskie', 'Kielce', '25-006'),
(6, 'ulica_3_Maja', 'Podkarpackie', 'Rzeszów', '35-030'),
(7, 'ulica_Lwowska_765', 'Podkarpackie', 'Rzeszów', '35-301'),
(8, 'Malawa_714', 'Podkarpackie', 'Malawa', '36-007'),
(9, 'ulica_Zamkowa_123', 'Podkarpackie', 'Rzeszów', '35-032'),
(10, 'ulica_Dąbrowskiego_5', 'Podkarpackie', 'Rzeszów', '35-043'),
(11, 'ulica_Dąbrowa_58', 'Podkarpackie', 'Rzeszów', '35-004'),
(12, 'ulica_Asfaltowa_12', 'Podkarpackie', 'Sanok', '35-123'),
(13, 'ulica_Hetmańska_54', 'Podkarpackie', 'Rzeszów', '35-145'),
(14, 'ulica_Słocińska_23', 'Podkarpackie', 'Przemyśl', '35-078'),
(15, 'ulica_P_Maja_11', 'Mazowieckie', 'Warszawa', '00-029'),
(16, 'ulica_Abrahama_21', 'Mazowieckie', 'Warszawa', '03-144'),
(17, 'ulica_Akcent_5', 'Mazowieckie', 'Warszawa', '01-870'),
(18, 'ulica_Akermańska_13', 'Mazowieckie', 'Warszawa', '03-144'),
(19, 'ulica_Alpejska_12', 'Mazowieckie', 'Warszawa', '01-870'),
(20, 'ulica_Bambusowa_7', 'Mazowieckie', 'Warszawa', '01-870'),
(21, 'ulica_Dymna_6', 'Mazowieckie', 'Warszawa', '03-144'),
(22, 'ulica_Dynamiczna_4', 'Mazowieckie', 'Warszawa', '01-870'),
(23, 'ulica_Godlewska_1', 'Mazowieckie', 'Warszawa', '03-144'),
(24, 'ulica_Graniczna_3', 'Mazowieckie', 'Warszawa', '00-029'),
(25, 'ulica_Grecka_9', 'Mazowieckie', 'Warszawa', '00-029'),
(26, 'ulica_Pasymska_1', 'Mazowieckie', 'Warszawa', '01-870'),
(27, 'ulica_Obozowa_8', 'Mazowieckie', 'Warszawa', '03-144'),
(28, 'ulica_Lubaleska_8', 'Pomorksie', 'Gdańsk', '80-253'),
(29, 'ulica_Klukowska_5', 'Pomorksie', 'Gdańsk', '80-110'),
(30, 'ulica_Zawiejska_11', 'Pomorksie', 'Gdańsk', '80-733'),
(31, 'ulica_Wronia_3', 'Pomorksie', 'Gdańsk', '80-690'),
(32, 'ulica_Wilcza_14', 'Pomorksie', 'Gdańsk', '80-733'),
(33, 'ulica_Szkolna_17', 'Podlaskie', 'Białystok', '15-640'),
(34, 'ulica_Ralska_7', 'Pomorksie', 'Gdańsk', '80-253'),
(35, 'ulica_Powalna_5', 'Pomorksie', 'Gdańsk', '80-733'),
(36, 'ulica_Opacka_4', 'Pomorksie', 'Gdańsk', '80-253'),
(37, 'ulica_Długa_6', 'Lubelskie', 'Lublin', '20-015'),
(38, 'ulica_Ciepła_3', 'Lubelskie', 'Lublin', '20-027'),
(39, 'ulica_Cicha_11', 'Lubelskie', 'Lublin', '20-005'),
(40, 'ulica_Laskowa_9', 'Lubelskie', 'Lublin', '20-015'),
(41, 'ulica_Kwiatowa_1', 'Lubelskie', 'Lublin', '20-027'),
(42, 'ulica_Naftowa_4', 'Lubelskie', 'Lublin', '20-005'),
(43, 'ulica_Poranna_12', 'Lubelskie', 'Lublin', '20-015'),
(44, 'ulica_Szklana_11', 'Lubelskie', 'Lublin', '20-027'),
(45, 'ulica_Sucha_6', 'Mazowieckie', 'Radom', '26-610'),
(46, 'ulica_Szeroka_8', 'Mazowieckie', 'Radom', '26-606'),
(47, 'ulica_Dworska_14', 'Mazowieckie', 'Radom', '26-617'),
(48, 'ulica_Krótka_9', 'Mazowieckie', 'Radom', '26-606'),
(49, 'ulica_Pusta_10', 'Mazowieckie', 'Radom', '26-617'),
(50, 'ulica_Płaska_7', 'Mazowieckie', 'Radom', '26-610'),
(51, 'Piastów 1', 'Podkarpackie', 'Rzeszów', '35-333'),
(52, 'Święcany 47', 'Podkarpacie', 'Rzeszów', '38-242'),
(53, 'Strzyżów', 'Podkarpackie', 'Jasło', '38-242'),
(54, 'Jasło 33', 'Podkarpackie', 'Rzeszów', '33-222'),
(55, 'Ropczyce 22', 'Podkarpackie', 'Rzeszów', '39-222');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `info_techniczne`
--

CREATE TABLE `info_techniczne` (
  `Info_techniczne_id` int(11) NOT NULL,
  `Moc_silnika` int(8) DEFAULT NULL,
  `Pojemność_silnika` int(8) DEFAULT NULL,
  `Przebieg` int(15) DEFAULT NULL,
  `Typ_silnika` varchar(20) DEFAULT NULL,
  `pojemnosc_bagaznika` int(3) NOT NULL,
  `skrzynia_biegow` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Zrzut danych tabeli `info_techniczne`
--

INSERT INTO `info_techniczne` (`Info_techniczne_id`, `Moc_silnika`, `Pojemność_silnika`, `Przebieg`, `Typ_silnika`, `pojemnosc_bagaznika`, `skrzynia_biegow`) VALUES
(1, 405, 4, 2000, 'hybrydowy', 2, 'manualna'),
(2, 477, 4, 12000, 'hybrydowy', 3, 'automatyczna'),
(3, 610, 5, 43243, 'benzynowy', 4, 'automatyczna'),
(4, 420, 4, 1234, 'diesel', 4, 'manualna'),
(5, 480, 3, 945, 'hybrydowy', 6, 'manualna'),
(6, 570, 3, 6540, 'hybrydowy', 6, 'automatyczna'),
(7, 669, 3, 3040, 'hybrydowy', 4, 'manualna'),
(8, 552, 5, 2540, 'benzynowy', 2, 'manualna'),
(9, 560, 5, 96594, 'benzynowy', 3, 'manualna'),
(10, 750, 6, 1230, 'diesel', 5, 'manualna'),
(11, 560, 3, 2345, 'hybrydowy', 2, 'manualna'),
(12, 450, 5, 7006, 'diesel', 6, 'automatyczna'),
(13, 362, 1, 100, 'benzynowy', 3, 'automatyczna'),
(14, 435, 4, 6799, 'benzynowy', 2, 'manualna'),
(15, 431, 2, 5469, 'hybrydowy', 7, 'manualna'),
(16, 510, 3, 9549, 'hybrydowy', 2, 'manualna'),
(17, 360, 1, 4300, 'diesel', 5, 'automatyczna'),
(18, 326, 2, 2149, 'benzynowy', 6, 'manualna'),
(19, 258, 2, 4888, 'diesel', 7, 'manualna'),
(20, 405, 4, 30993, 'hybrydowy', 3, 'manualna'),
(21, 477, 4, 79054, 'hybrydowy', 7, 'automatyczna'),
(22, 610, 5, 32004, 'hybrydowy', 5, 'manualna'),
(23, 420, 4, 54003, 'diesel', 2, 'manualna'),
(24, 480, 3, 34500, 'hybrydowy', 5, 'manualna'),
(25, 570, 3, 95439, 'benzynowy', 6, 'manualna'),
(26, 669, 3, 3003, 'benzynowy', 3, 'automatyczna'),
(27, 552, 5, 4399, 'hybrydowy', 3, 'automatyczna'),
(28, 560, 5, 21004, 'hybrydowy', 7, 'automatyczna'),
(29, 750, 6, 43200, 'hybrydowy', 2, 'automatyczna'),
(30, 560, 3, 54043, 'benzynowy', 6, 'automatyczna'),
(31, 450, 5, 65000, 'benzynowy', 5, 'automatyczna'),
(32, 362, 1, 34290, 'diesel', 4, 'automatyczna'),
(33, 435, 4, 54949, 'diesel', 5, 'manualna'),
(34, 431, 2, 12030, 'benzynowy', 6, 'manualna'),
(35, 510, 3, 20003, 'hybrydowy', 3, 'automatyczna'),
(36, 360, 1, 40300, 'hybrydowy', 5, 'automatyczna'),
(37, 326, 2, 2000, 'hybrydowy', 3, 'manualna'),
(38, 258, 2, 3230, 'benzynowy', 5, 'manualna'),
(39, 405, 4, 12340, 'diesel', 4, 'manualna'),
(40, 477, 4, 24324, 'benzynowy', 7, 'automatyczna'),
(41, 610, 5, 23124, 'hybrydowy', 5, 'manualna'),
(42, 420, 4, 12300, 'benzynowy', 4, 'manualna'),
(43, 430, 3, 47537, 'benzynowy', 2, 'automatyczna'),
(44, 477, 4, 3000, 'benzynowy', 4, 'manualna'),
(45, 630, 5, 12310, 'diesel', 2, 'automatyczna'),
(46, 420, 4, 54332, 'diesel', 5, 'automatyczna'),
(47, 480, 3, 60005, 'hybrydowy', 6, 'manualna'),
(48, 410, 3, 12335, 'benzynowy', 4, 'manualna'),
(49, 480, 3, 12399, 'diesel', 5, 'automatyczna'),
(50, 460, 5, 41294, 'diesel', 4, 'automatyczna');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `klient`
--

CREATE TABLE `klient` (
  `Klient_id` int(11) NOT NULL,
  `Adres_id` int(11) DEFAULT NULL,
  `Imie` varchar(20) DEFAULT NULL,
  `Nazwisko` varchar(20) DEFAULT NULL,
  `Data_urodzenia` date DEFAULT NULL,
  `Nr_telefonu` int(9) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Zrzut danych tabeli `klient`
--

INSERT INTO `klient` (`Klient_id`, `Adres_id`, `Imie`, `Nazwisko`, `Data_urodzenia`, `Nr_telefonu`) VALUES
(1, 11, 'Krzysztof', 'Kowalski', '1999-12-04', 476912059),
(2, 50, 'Adam', 'Nowak', '1976-10-15', 414867865),
(3, 5, 'Jan', 'Kowalski', '1969-08-30', 830402932),
(4, 47, 'Dariusz', 'Malinowski', '1990-02-12', 345678909),
(5, 44, 'Mariusz', 'Adamewicz', '1980-04-23', 952584372),
(6, 46, 'Maciej', 'Robak', '1995-02-14', 643678901),
(7, 30, 'Rafał', 'Lipa', '1999-10-28', 996678901),
(8, 7, 'Łukasz', 'Lampard', '1976-09-02', 324678901),
(9, 34, 'Błażej', 'Zwoliński', '1989-06-22', 997678909),
(10, 33, 'Cezary', 'Świerk', '1972-04-13', 168381320),
(11, 38, 'Kacper', 'Nowakowski', '1973-12-05', 967617114),
(12, 12, 'Karol', 'Kamecki', '1974-04-05', 481433516),
(13, 24, 'Arkadiusz', 'Wojnicki', '1978-04-01', 634422049),
(14, 25, 'Michał', 'Lasecki', '1978-05-22', 396072175),
(15, 8, 'Wojciech', 'Walicki', '1979-04-23', 997678909),
(16, 2, 'Krzysztof', 'Walczyk', '1981-11-20', 372368426),
(17, 40, 'Kamil', 'Kmieciak', '1984-10-06', 123826574),
(18, 19, 'Filip', 'Nowak', '1985-04-18', 337750007),
(19, 31, 'Mateusz', 'Świerk', '1985-11-21', 242434246),
(20, 15, 'Henryk', 'Urban', '1987-05-27', 869514677),
(21, 13, 'Łukasz', 'Filar', '1987-11-22', 997678909),
(22, 20, 'Adam', 'Kowalski', '1988-01-29', 386764328),
(23, 1, 'Wiola', 'Zatorski', '1990-09-06', 400727721),
(24, 27, 'Julia', 'Świerk', '1990-10-24', 229029095),
(25, 23, 'Natalia', 'Nowak', '1990-11-14', 814572323),
(26, 48, 'Sławomir', 'Adamowski', '1992-03-15', 556590137),
(27, 18, 'Oliwier', 'Kowalski', '1995-01-13', 505947812),
(28, 21, 'Klaudia', 'Rzeźnik', '1993-05-05', 996947690),
(29, 32, 'Zbigniew', 'Świerk', '1995-06-26', 500576325),
(30, 9, 'Zygmunt', 'Dąbrowski', '1995-12-22', 208985535),
(31, 39, 'Anastazja', 'Nowak', '1999-11-15', 401827280),
(32, 36, 'Alicja', 'Kowalski', '2000-02-11', 419160016),
(33, 16, 'Beata', 'Tkaczuk', '2002-02-20', 879766590),
(34, 37, 'Dagmara', 'Urbański', '1989-06-22', 664659762),
(35, 4, 'Gabriela', 'Smoła', '2003-07-14', 683761070),
(36, 6, 'Anna', 'Wełna', '1973-11-15', 399200263),
(37, 49, 'Felicja', 'Kowalski', '1973-12-22', 678271752),
(38, 14, 'Jadwiga', 'Malarz', '1989-06-22', 532271916),
(39, 3, 'Laura', 'Papiernik', '1974-06-09', 487962963),
(40, 41, 'Małgorzata', 'Nowak', '1977-09-12', 485106943),
(41, 29, 'Malwina', 'Nowakowski', '1979-08-19', 721978916),
(42, 45, 'Nikola', 'Antkowiak', '1986-07-18', 107617632),
(43, 35, 'Paulina', 'Nowak', '1986-10-24', 723737669),
(44, 22, 'Wiktoria', 'Janiec', '1987-03-18', 827238686),
(45, 42, 'Robert', 'Kowalski', '1987-11-11', 678770828),
(46, 17, 'Sabina', 'Skop', '1990-08-17', 219239428),
(47, 26, 'Jan', 'Nowak', '1990-11-07', 596381967),
(48, 43, 'Janusz', 'Świerk', '1993-02-12', 789149330),
(49, 10, 'Kamil', 'Kowalski', '1997-07-25', 198434529),
(50, 28, 'Andrzej', 'Bartkowicz', '1999-01-29', 237584372),
(51, 51, 'Adam', 'Małysz', '1977-11-02', 123123123),
(52, 52, 'Karol', 'Wojnar', '2001-09-26', 442332221),
(53, 53, 'Arek', 'Rybka', '2002-02-02', 555444123),
(54, 54, 'Krzysztof', 'Wałek', '2001-01-01', 929929991),
(55, 55, 'Kacper', 'Śmiałek', '2001-01-03', 323441133);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pracownicy`
--

CREATE TABLE `pracownicy` (
  `przydzielony_pracownik_id` int(5) NOT NULL,
  `imie` varchar(20) DEFAULT NULL,
  `nazwisko` varchar(28) DEFAULT NULL,
  `nr_tel` int(11) DEFAULT NULL,
  `email` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `pracownicy`
--

INSERT INTO `pracownicy` (`przydzielony_pracownik_id`, `imie`, `nazwisko`, `nr_tel`, `email`) VALUES
(1, 'Julia', 'Nowak', 954832123, 'julia.nowak@example.com'),
(2, 'Michał', 'Jankowski', 987654321, 'michal.jankowski@example.'),
(3, 'Anna', 'Wiśniewska', 111222333, 'anna.wisniewska@example.c'),
(4, 'Mateusz', 'Wójcik', 444555666, 'mateusz.wojcik@example.co'),
(5, 'Katarzyna', 'Kowalczyk', 777888999, ' katarzyna.kowalczyk@exam'),
(6, 'Jakub', 'Kozłowski', 555666777, 'jakub.kozlowski@example.c'),
(7, 'Natalia', 'Mazur', 222333444, 'natalia.mazur@example.com'),
(8, 'Paweł', 'Sikora', 666777888, 'pawel.sikora@example.com'),
(9, 'Marta', 'Górka', 333444555, 'marta.gorka@example.com'),
(10, 'Piotr', 'Zając', 888999000, 'piotr.zajac@example.com');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `samochód`
--

CREATE TABLE `samochód` (
  `Samochód_id` int(11) NOT NULL,
  `Marka` varchar(25) DEFAULT NULL,
  `Model` varchar(25) DEFAULT NULL,
  `Info_techniczne_id` int(11) DEFAULT NULL,
  `Liczba_drzwi` int(2) DEFAULT NULL,
  `Ilość_miejsc` int(2) DEFAULT NULL,
  `Rok_produkcji` year(4) DEFAULT NULL,
  `dostepnosc` varchar(25) NOT NULL,
  `Klasa` varchar(1) NOT NULL,
  `wypozyczalnia_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Zrzut danych tabeli `samochód`
--

INSERT INTO `samochód` (`Samochód_id`, `Marka`, `Model`, `Info_techniczne_id`, `Liczba_drzwi`, `Ilość_miejsc`, `Rok_produkcji`, `dostepnosc`, `Klasa`, `wypozyczalnia_id`) VALUES
(1, 'Mercedes', 'AMG GT', 1, 3, 2, 2020, 'dostepny', 'B', 4),
(2, 'Mercedes', 'Citan', 2, 5, 5, 2021, 'wypozyczony', 'A', 2),
(3, 'Mercedes', 'CLA', 3, 3, 4, 2022, 'dostepny', 'A', 4),
(4, 'Mercedes', 'CLS', 4, 3, 2, 2016, 'dostepny', 'C', 1),
(5, 'Mercedes', 'EQA', 5, 3, 2, 2020, 'dostepny', 'C', 3),
(6, 'BMW', 'M2', 6, 3, 2, 2010, 'dostepny', 'A', 2),
(7, 'BMW', 'M3', 7, 3, 2, 2014, 'dostepny', 'A', 4),
(8, 'BMW', 'M4', 8, 3, 2, 2016, 'dostepny', 'A', 1),
(9, 'BMW', 'X5', 9, 5, 5, 2013, 'dostepny', 'D', 1),
(10, 'BMW', 'X6', 10, 5, 5, 2015, 'dostepny', 'B', 4),
(11, 'BMW', 'X4', 11, 5, 5, 2017, 'dostepny', 'B', 5),
(12, 'Volkswagen', 'Polo', 12, 5, 5, 2009, 'dostepny', 'D', 3),
(13, 'Volkswagen', 'Tiguan', 13, 5, 5, 2011, 'wypozyczony', 'A', 3),
(14, 'Volkswagen', 'T-Cross', 14, 5, 5, 2008, 'wypozyczony', 'A', 5),
(15, 'Volkswagen', 'Passat', 15, 5, 5, 2013, 'dostepny', 'C', 3),
(16, 'Volkswagen', 'Caddy', 16, 5, 5, 2011, 'dostepny', 'A', 4),
(17, 'Audi', 'A5', 17, 3, 2, 2011, 'dostepny', 'D', 1),
(18, 'Audi', 'A6', 18, 3, 4, 2014, 'dostepny', 'D', 4),
(19, 'Audi', 'A7', 19, 3, 2, 2018, 'dostepny', 'B', 5),
(20, 'Audi', 'Q7', 20, 5, 5, 2020, 'dostepny', 'A', 2),
(21, 'Audi', 'Q8', 21, 5, 5, 2021, 'dostepny', 'C', 5),
(22, 'Toyota', 'Aygo X', 22, 3, 2, 2021, 'dostepny', 'A', 2),
(23, 'Toyota', 'bZ4X', 23, 3, 2, 2020, 'wypozyczony', 'C', 4),
(24, 'Toyota', 'C-HR', 24, 3, 2, 2016, 'dostepny', 'A', 1),
(25, 'Toyota', 'Camry', 25, 3, 4, 2022, 'dostepny', 'B', 3),
(26, 'Toyota', 'Corolla', 26, 5, 5, 2011, 'dostepny', 'C', 1),
(27, 'Toyota', 'Highlander', 27, 5, 5, 2015, 'dostepny', 'D', 1),
(28, 'Mazda', 'CX‑60', 28, 3, 2, 2004, 'dostepny', 'D', 1),
(29, 'Mazda', 'MX‑30', 29, 5, 5, 2006, 'dostepny', 'C', 5),
(30, 'Mazda', 'CX‑5', 30, 3, 2, 2011, 'dostepny', 'C', 2),
(31, 'Mazda', 'CX‑30', 31, 5, 5, 2009, 'dostepny', 'D', 3),
(32, 'Mazda', 'Hybrid', 32, 3, 2, 2007, 'dostepny', 'C', 1),
(33, 'Mazda', 'CX-3', 33, 3, 4, 2013, 'dostepny', 'B', 1),
(34, 'Opel', 'Astra', 34, 5, 5, 2011, 'dostepny', 'B', 2),
(35, 'Opel', 'Combo', 35, 5, 5, 2014, 'dostepny', 'D', 4),
(36, 'Opel', 'Corsa', 36, 3, 4, 2016, 'dostepny', 'D', 1),
(37, 'Opel', 'Insignia', 37, 3, 4, 2020, 'dostepny', 'A', 4),
(38, 'Opel', 'Mokka', 38, 5, 5, 2018, 'wypozyczony', 'C', 5),
(39, 'Opel', 'Movano', 39, 3, 2, 2021, 'dostepny', 'B', 2),
(40, 'Kia', 'Picanto', 40, 3, 2, 2020, 'dostepny', 'A', 2),
(41, 'Kia', 'Rio', 41, 5, 5, 2022, 'dostepny', 'A', 1),
(42, 'Kia', 'Ceed', 42, 3, 4, 2013, 'dostepny', 'D', 1),
(43, 'Kia', 'Proceed', 43, 3, 2, 2012, 'dostepny', 'C', 5),
(44, 'Kia', 'XCeed', 44, 3, 4, 2017, 'dostepny', 'D', 4),
(45, 'Hyundai', 'i10', 45, 3, 2, 2020, 'dostepny', 'B', 1),
(46, 'Hyundai', 'i20', 46, 3, 2, 2007, 'dostepny', 'D', 5),
(47, 'Hyundai', 'i30', 47, 3, 2, 2009, 'dostepny', 'A', 5),
(48, 'Hyundai', 'Kona', 48, 5, 5, 2020, 'dostepny', 'A', 3),
(49, 'Hyundai', 'Elantra', 49, 3, 2, 2011, 'dostepny', 'D', 3),
(50, 'Hyundai', 'Bayon', 50, 5, 5, 2015, 'dostepny', 'D', 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `wypozyczalnia`
--

CREATE TABLE `wypozyczalnia` (
  `wypozyczalnia_id` int(11) NOT NULL,
  `nazwa` varchar(25) DEFAULT NULL,
  `adres` varchar(25) DEFAULT NULL,
  `kod_poczt` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `wypozyczalnia`
--

INSERT INTO `wypozyczalnia` (`wypozyczalnia_id`, `nazwa`, `adres`, `kod_poczt`) VALUES
(1, 'SpeedyWheels', 'Piastow 11', '35-077 Rzeszow'),
(2, 'DriveAwayRentals', 'Debicka 12', '45-110 Poznan'),
(3, 'AutoRentalXpress', 'Poznanska 12', '41-331 Warszawa'),
(4, 'RoadRunnersRent', 'Urzednicza 2', '00-010 Warszawa'),
(5, 'Cruise-N-Drive', 'Cicha 8', '35-072 Rzeszow');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `wypożyczenia`
--

CREATE TABLE `wypożyczenia` (
  `Wypożyczenia_id` int(11) NOT NULL,
  `Klient_id` int(11) NOT NULL,
  `Samochód_id` int(11) NOT NULL,
  `Data_wypożyczenia` date DEFAULT NULL,
  `Data_zwrotu` date DEFAULT NULL,
  `Koszt` int(8) DEFAULT NULL,
  `typ_ubezpieczenia` varchar(25) NOT NULL,
  `przydzielony_pracownik_id` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Zrzut danych tabeli `wypożyczenia`
--

INSERT INTO `wypożyczenia` (`Wypożyczenia_id`, `Klient_id`, `Samochód_id`, `Data_wypożyczenia`, `Data_zwrotu`, `Koszt`, `typ_ubezpieczenia`, `przydzielony_pracownik_id`) VALUES
(1, 5, 4, '2023-05-22', '2023-05-25', 270, 'brak', 1),
(2, 5, 2, '2023-06-01', '2023-06-05', 640, 'brak', 5),
(3, 12, 13, '2023-06-01', '2023-06-04', 720, 'całkowite', 7),
(4, 8, 14, '2023-06-01', '2023-06-06', 1040, 'od kradzieży', 4),
(5, 7, 23, '2023-06-02', '2023-06-07', 675, 'całkowite', 5),
(6, 55, 38, '2023-06-01', '2023-06-03', 180, 'brak', 5);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `adres`
--
ALTER TABLE `adres`
  ADD PRIMARY KEY (`Adres_id`);

--
-- Indeksy dla tabeli `info_techniczne`
--
ALTER TABLE `info_techniczne`
  ADD PRIMARY KEY (`Info_techniczne_id`);

--
-- Indeksy dla tabeli `klient`
--
ALTER TABLE `klient`
  ADD PRIMARY KEY (`Klient_id`),
  ADD KEY `Adres_id` (`Adres_id`);

--
-- Indeksy dla tabeli `pracownicy`
--
ALTER TABLE `pracownicy`
  ADD PRIMARY KEY (`przydzielony_pracownik_id`);

--
-- Indeksy dla tabeli `samochód`
--
ALTER TABLE `samochód`
  ADD PRIMARY KEY (`Samochód_id`),
  ADD KEY `Info_techniczne_id` (`Info_techniczne_id`),
  ADD KEY `wypozyczalnia_id` (`wypozyczalnia_id`);

--
-- Indeksy dla tabeli `wypozyczalnia`
--
ALTER TABLE `wypozyczalnia`
  ADD PRIMARY KEY (`wypozyczalnia_id`);

--
-- Indeksy dla tabeli `wypożyczenia`
--
ALTER TABLE `wypożyczenia`
  ADD PRIMARY KEY (`Wypożyczenia_id`),
  ADD KEY `Samochód_id` (`Samochód_id`),
  ADD KEY `Klient_id` (`Klient_id`),
  ADD KEY `przydzielony_pracownik_id` (`przydzielony_pracownik_id`);

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `klient`
--
ALTER TABLE `klient`
  ADD CONSTRAINT `klient_ibfk_1` FOREIGN KEY (`Adres_id`) REFERENCES `adres` (`Adres_id`);

--
-- Ograniczenia dla tabeli `samochód`
--
ALTER TABLE `samochód`
  ADD CONSTRAINT `samochód_ibfk_1` FOREIGN KEY (`Info_techniczne_id`) REFERENCES `info_techniczne` (`Info_techniczne_id`),
  ADD CONSTRAINT `samochód_ibfk_2` FOREIGN KEY (`wypozyczalnia_id`) REFERENCES `wypozyczalnia` (`wypozyczalnia_id`);

--
-- Ograniczenia dla tabeli `wypożyczenia`
--
ALTER TABLE `wypożyczenia`
  ADD CONSTRAINT `wypożyczenia_ibfk_1` FOREIGN KEY (`Samochód_id`) REFERENCES `samochód` (`Samochód_id`),
  ADD CONSTRAINT `wypożyczenia_ibfk_2` FOREIGN KEY (`Klient_id`) REFERENCES `klient` (`Klient_id`),
  ADD CONSTRAINT `wypożyczenia_ibfk_3` FOREIGN KEY (`przydzielony_pracownik_id`) REFERENCES `pracownicy` (`przydzielony_pracownik_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
