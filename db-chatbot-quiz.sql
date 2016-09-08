-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 08, 2016 at 09:41 AM
-- Server version: 5.5.47-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `duc-chatbot-quiz`
--

-- --------------------------------------------------------

--
-- Table structure for table `question`
--

CREATE TABLE IF NOT EXISTS `question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `a1` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `a2` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `a3` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `a4` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `correct` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `car` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=19 ;

--
-- Dumping data for table `question`
--

INSERT INTO `question` (`id`, `question`, `a1`, `a2`, `a3`, `a4`, `correct`, `car`) VALUES
(1, 'Bạn hãy cho biết công nghệ dẫn động 4 bánh trên dòng xe Suzuki Vitara có tên là gì', 'Quattro', '4Matic', 'All-Grip', 'SH AWD', 'All-Grip', 'vitara'),
(2, 'Bạn hãy cho biết dòng xe Suzuki Vitara thuộc phân khúc nào?', 'Sedan', 'MPV', 'SUV', 'Hatchback', 'SUV', 'vitara'),
(3, 'Bạn hãy cho biết Suzuki Vitara có bao nhiêu màu xe cho bạn lựa chọn?', '4 màu', '8 màu', '10 màu', '14 màu', '14 màu', 'vitara'),
(4, 'Bạn hãy cho biết Suzuki Vitara được ra mắt lần đầu tiên vào năm nào?', '1988', '1998', '2005', '2015', '1988', 'vitara'),
(5, 'Bạn hãy cho biết dòng xe Suzuki Ertiga có thể chở bao nhiêu khách?', '2', '5', '5+2', '7', '7', 'ertiga'),
(6, 'Bạn hãy cho biết dòng xe Suzuki Ertiga thuộc phân khúc nào?', 'Sedan', 'MPV', 'SUV', 'Hatchback', 'MPV', 'ertiga'),
(7, 'Bạn hãy cho biết dòng xe Suzuki Ciaz thuộc phân khúc nào?', 'Sedan', 'MPV', 'SUV', 'Hatchback', 'Sedan', 'ciaz'),
(8, 'Bạn hãy cho biết Suzuki Ciaz được nhập khẩu từ nước nào?', 'Indonesia', 'Thái Lan', 'Ấn Độ', 'Hungary', 'Thái Lan', 'ciaz'),
(9, 'Bạn hãy cho biết Suzuki Ciaz được trang bị các tính năng an toàn nào?', 'Phanh ABS phân bổ lực phanh điện tử EBD', 'Túi khí đôi', 'Bánh xe lớn 16 inch', 'Tất cả những tính năng trên', 'Tất cả những tính năng trên', 'ciaz'),
(10, 'Bạn hãy cho biết dòng xe Suzuki Swift thuộc phân khúc nào?', 'Sedan', 'MPV', 'SUV', 'Hatchback', 'Hatchback', 'swift'),
(11, 'Theo bạn xe Suzuki Vitara có mấy bánh xe?', '2', '3', '4', '10', '4', 'vitara'),
(12, 'Theo bạn xe Suzuki Swift có mấy bánh xe?', '2', '3', '4', '10', '4', 'swift'),
(13, 'Theo bạn xe Suzuki Ciaz có mấy bánh xe?', '2', '3', '4', '10', '4', 'ciaz'),
(14, 'Theo bạn xe Suzuki Ertiga có mấy bánh xe?', '2', '3', '4', '10', '4', 'ertiga'),
(15, 'Theo bạn xe động cơ Suzuki Swift có mấy xi lanh?', '2', '3', '4', '10', '4', 'swift'),
(16, 'Theo bạn xe động cơ Suzuki Ciaz có mấy xi lanh?', '2', '3', '4', '10', '4', 'ciaz'),
(17, 'Theo bạn xe động cơ Suzuki Ertiga có mấy xi lanh?', '2', '3', '4', '10', '4', 'ertiga'),
(18, 'Theo bạn xe động cơ Suzuki Vitara có mấy xi lanh?', '2', '3', '4', '10', '4', 'vitara');

-- --------------------------------------------------------

--
-- Table structure for table `session`
--

CREATE TABLE IF NOT EXISTS `session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fb_id` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `session_id` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `question_id` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `answer` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `correct` tinyint(4) NOT NULL,
  `begin_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` tinyint(1) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=55 ;

--
-- Dumping data for table `session`
--

INSERT INTO `session` (`id`, `fb_id`, `session_id`, `question_id`, `answer`, `correct`, `begin_time`, `status`) VALUES
(1, '1075573532514771', '57cfc7d2ad54c', '6', 'MPV', 1, '2016-09-07 07:55:15', 0),
(2, '1075573532514771', '57cfc7d2ad54c', '14', '4', 1, '2016-09-07 07:55:15', 0),
(3, '1075573532514771', '57cfc7d2ad54c', '5', '7', 1, '2016-09-07 07:55:15', 0),
(4, '1075573532514771', '57cfc7f220eb7', '6', 'Hatchback', 0, '2016-09-07 07:55:42', 0),
(5, '1075573532514771', '57cfc7f220eb7', '14', '10', 0, '2016-09-07 07:55:42', 0),
(6, '1075573532514771', '57cfc7f220eb7', '17', '10', 0, '2016-09-07 07:55:42', 0),
(7, '1075573532514771', '57cfc97c4e450', '4', '1998', 0, '2016-09-07 08:02:20', 0),
(8, '1075573532514771', '57cfc97c4e450', '18', '10', 0, '2016-09-07 08:02:20', 0),
(9, '1075573532514771', '57cfc97c4e450', '3', '10 màu', 0, '2016-09-07 08:02:20', 0),
(10, '1075573532514771', '57cfca84b40d7', '7', 'MPV', 0, '2016-09-07 08:06:53', 0),
(11, '1075573532514771', '57cfca84b40d7', '13', '3', 0, '2016-09-07 08:06:53', 0),
(12, '1075573532514771', '57cfca84b40d7', '16', '2', 0, '2016-09-07 08:06:53', 0),
(13, '1226577910716572', '57cfcac7287e7', '10', 'Sedan', 0, '2016-09-07 08:08:06', 0),
(14, '1226577910716572', '57cfcac7287e7', '15', '4', 1, '2016-09-07 08:08:06', 0),
(15, '1226577910716572', '57cfcac7287e7', '12', '4', 1, '2016-09-07 08:08:06', 0),
(16, '1075573532514771', '57cfcaec2cd38', '1', 'Quattro', 0, '2016-09-07 08:08:31', 0),
(17, '1075573532514771', '57cfcaec2cd38', '2', 'Hatchback', 0, '2016-09-07 08:08:31', 0),
(18, '1075573532514771', '57cfcaec2cd38', '4', '2015', 0, '2016-09-07 08:08:31', 0),
(19, '1226577910716572', '57cfcb975de31', '14', '3', 0, '2016-09-07 08:15:11', 0),
(20, '1226577910716572', '57cfcb975de31', '17', '', 0, '2016-09-07 08:15:11', 0),
(21, '1226577910716572', '57cfcb975de31', '16', '10', 0, '2016-09-07 08:15:11', 0),
(22, '1226577910716572', '57cfcca219bb4', '17', '4', 1, '2016-09-07 08:15:52', 0),
(23, '1226577910716572', '57cfcca219bb4', '14', '10', 0, '2016-09-07 08:15:52', 0),
(24, '1226577910716572', '57cfcca219bb4', '5', '5+2', 0, '2016-09-07 08:15:52', 0),
(25, '1226577910716572', '57cfcce73469d', '6', 'Hatchback', 0, '2016-09-07 08:17:00', 0),
(26, '1226577910716572', '57cfcce73469d', '14', '10', 0, '2016-09-07 08:17:00', 0),
(27, '1226577910716572', '57cfcce73469d', '5', '7', 1, '2016-09-07 08:17:00', 0),
(28, '1226577910716572', '57cfcd31a1a7c', '1', 'SH AWD', 0, '2016-09-07 08:18:21', 0),
(29, '1226577910716572', '57cfcd31a1a7c', '18', '4', 1, '2016-09-07 08:18:21', 0),
(30, '1226577910716572', '57cfcd31a1a7c', '3', '4 màu', 0, '2016-09-07 08:18:21', 0),
(31, '1226577910716572', '57cfcea15a375', '15', '10', 0, '2016-09-07 08:26:52', 0),
(32, '1226577910716572', '57cfcea15a375', '12', '4', 1, '2016-09-07 08:26:52', 0),
(33, '1226577910716572', '57cfcea15a375', '10', 'Hatchback', 1, '2016-09-07 08:26:52', 0),
(34, '1075573532514771', '57cfd02597c44', '14', '', 0, '2016-09-07 08:32:13', 0),
(35, '1075573532514771', '57cfd02597c44', '17', '10', 0, '2016-09-07 08:32:13', 0),
(36, '1075573532514771', '57cfd02597c44', '5', '5+2', 0, '2016-09-07 08:32:13', 0),
(37, '1075573532514771', '57cfd0c94769d', '5', '7', 1, '2016-09-07 08:33:35', 0),
(38, '1075573532514771', '57cfd0c94769d', '6', 'Sedan', 0, '2016-09-07 08:33:35', 0),
(39, '1075573532514771', '57cfd0c94769d', '14', '10', 0, '2016-09-07 08:33:35', 0),
(40, '1075573532514771', '57cfd23f16bd2', '17', '10', 0, '2016-09-07 08:39:41', 0),
(41, '1075573532514771', '57cfd23f16bd2', '6', 'Hatchback', 0, '2016-09-07 08:39:41', 0),
(42, '1075573532514771', '57cfd23f16bd2', '5', '7', 1, '2016-09-07 08:39:41', 0),
(43, '1075573532514771', '57cfd5d3536df', '17', '10', 0, '2016-09-07 08:54:56', 0),
(44, '1075573532514771', '57cfd5d3536df', '14', '10', 0, '2016-09-07 08:54:56', 0),
(45, '1075573532514771', '57cfd5d3536df', '6', 'Sedan', 0, '2016-09-07 08:54:56', 0),
(46, '1075573532514771', '57cfd653946e7', '15', '4', 1, '2016-09-07 08:57:08', 0),
(47, '1075573532514771', '57cfd653946e7', '12', '4', 1, '2016-09-07 08:57:08', 0),
(48, '1075573532514771', '57cfd653946e7', '10', 'Hatchback', 1, '2016-09-07 08:57:08', 0),
(49, '1288391347841624', '57cfde17b0b65', '14', '2', 0, '2016-09-07 09:45:34', 0),
(50, '1288391347841624', '57cfde17b0b65', '17', '10', 0, '2016-09-07 09:45:34', 0),
(51, '1288391347841624', '57cfde17b0b65', '5', '2', 0, '2016-09-07 09:45:34', 0),
(52, '1076286582453976', '57cfe152ca35e', '5', '5+2', 0, '2016-09-07 10:17:37', 0),
(53, '1076286582453976', '57cfe152ca35e', '14', '10', 0, '2016-09-07 10:17:37', 0),
(54, '1076286582453976', '57cfe152ca35e', '6', 'Hatchback', 0, '2016-09-07 10:17:37', 0);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `fb_id` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `firstname` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `lastname` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `locale` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `gender` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`fb_id`),
  UNIQUE KEY `fb_id` (`fb_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`fb_id`, `firstname`, `lastname`, `locale`, `gender`) VALUES
('1075573532514771', 'Duc', 'Vu', 'en_US', 'male');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
