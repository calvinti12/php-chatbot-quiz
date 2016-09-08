<?php

$verify_token = 'xx'; // Verify token
$token = 'xx'; // Page token

require_once dirname(__FILE__).'/vendor/autoload.php';
use pimax\FbBotApp;
use pimax\Messages\Message;
use pimax\Messages\ImageMessage;
use pimax\UserProfile;
use pimax\Messages\MessageButton;
use pimax\Messages\StructuredMessage;
use pimax\Messages\MessageElement;
use pimax\Messages\MessageReceiptElement;
use pimax\Messages\Address;
use pimax\Messages\QuickReply;
use pimax\Messages\Summary;
use pimax\Messages\Adjustment;
use Monolog\Logger;
use Monolog\Handler\StreamHandler;

// Initialize db connection
$database = new medoo([
    'database_type' => 'mysql',
    'database_name' => 'db-name-here',
    'server' => 'localhost',
    'username' => 'xxx',
    'password' => 'xxx',
    'charset' => 'utf8',
]);


// Make Bot Instance
$bot = new FbBotApp($token);

// Create a log channel
$log = new Logger('chatbot');
$log->pushHandler(new StreamHandler('./err.txt', Logger::WARNING));

// Global variables
$fb_id = '';
$session_limit = 3;
$session_id = '0';
$command = '';
$payload = '';
$current_car = '';

function nextQuestion($current_car)
{
    global $bot,$database,$log,$fb_id,$session_limit,$session_id,$command,$payload;
    $log->warning('$current_car:');
    // begin issue question
    $user = $bot->userProfile($message['sender']['id']);
    if (!($database->has('user', ['fb_id' => $fb_id]))) {
        //user not exists
        $database->insert('user', [
          'fb_id' => $fb_id,
          'firstname' => $user->getFirstName(),
          'lastname' => $user->getLastName(),
          'locale' => $user->getLocale(),
          'gender' => $user->getGender(),
        ]);
    }

    //select session table to find current session, which are answered question
    //to select 1 random question which is not selected.
    $datas = $database->select('session', ['session_id', 'question_id'], [
        'AND' => [
        'fb_id' => $fb_id,
        'status' => 1,
        ],
    ]);
    $log->warning(var_export("select session: ".$database->last_query(), true));
    $log->warning('select session: $datas='.var_export($datas, true));

    if (!empty($datas)) {
        foreach ($datas as $da) {
            $answer[] = $da[question_id];
            $session_id = $da[session_id];
        }
        $selectedQuestion = $database->query("SELECT * FROM question WHERE id
          NOT IN (".implode(',', $answer).") AND car = '".$current_car."' ORDER BY RAND() LIMIT 1")->fetchAll();
    } else {
        $selectedQuestion = $database->query("SELECT * FROM question WHERE car = '".$current_car. "' ORDER BY RAND() LIMIT 1")->fetchAll();
    }

    $log->warning('pick random: '.var_export($database->last_query(), true));
    $log->warning('pick random: $datas='.var_export($selectedQuestion, true));


    if ($session_id == '0') {
        $session_id = uniqid();
    }

    $count = $database->count('session', [
      'AND' => [
        'fb_id' => $fb_id,
        'status' => 1,
        'session_id' => $session_id,
        ],
    ]);

    //$log->warning(var_export($database->last_query(), true));
    //$log->warning('$count='.var_export($count, true));

    if ($count >= $session_limit) {
        $count_point = $database->count('session', [
          'AND' => [
            'fb_id' => $fb_id,
            'status' => 1,
            'session_id' => $session_id,
            'correct' => 1,
            ],
        ]);

        //$log->warning(var_export($database->last_query(), true));
        //$log->warning('$count='.var_export($count_point, true));
        $summary_message = '';
        switch ($count_point) {
            case (0):
                $summary_message =  'Qua '.$session_limit.' câu hỏi mà bạn chưa trả lời đúng câu nào cả.'.
                  ' Bạn hãy tìm hiểu kỹ thêm về các dòng xe Suzuki và thử lại nhé.'.
                  ' Hãy gõ "chọn xe" để chơi lại.';
                break;
            case (1):
                $summary_message =  'Bạn đã hoàn thành '.$session_limit.' câu hỏi.'.
                  ' Số điểm của bạn là: '.$count_point.' điểm. Bạn cần cố gắng nhiều nhé.'.
                  ' Hãy gõ "chọn xe" để chơi lại.';
                break;
            case (3):
                $summary_message =  'Bạn đã hoàn thành '.$session_limit.' câu hỏi.'.
                  ' Với số điểm tuyệt đối. Bạn sẽ có tên trong danh sách rút thăm may mắn ngày hôm nay.'.
                  ' Nếu vẫn muốn thử tài, hãy gõ "chọn xe" để chơi lại.';
                break;

            default:
                $summary_message =  'Chúc mừng bạn đã hoàn thành '.$session_limit.' câu hỏi.'.
                  ' Số điểm của bạn là: '.$count_point.' điểm.'.
                  ' Hãy gõ "chọn xe" để chơi lại.';
                break;
        }

        $bot->send(new Message($fb_id, $summary_message));
        $database->update('session', ['status' => 0], [
        'AND' => [
          'fb_id' => $fb_id,
          'session_id' => $session_id,
          ],
        ]);
        exit;
    }

    $database->insert('session', [
        'fb_id' => $fb_id,
        'question_id' => $selectedQuestion[0][id],
        'session_id' => $session_id,
        'status' => 1,
    ]);
    $log->warning('check point: 1');
    $bot->send(new QuickReply(
        $fb_id,
        $selectedQuestion[0][question],
        [
          [
            'content_type' => 'text',
            'title' => $selectedQuestion[0][a1],
            'payload' => $fb_id.'#'.$session_id.'#'.$selectedQuestion[0][id].'#'.$selectedQuestion[0][a1].'#'.$selectedQuestion[0][car],
          ],
          [
            'content_type' => 'text',
            'title' => $selectedQuestion[0][a2],
            'payload' => $fb_id.'#'.$session_id.'#'.$selectedQuestion[0][id].'#'.$selectedQuestion[0][a2].'#'.$selectedQuestion[0][car],
          ],
          [
            'content_type' => 'text',
            'title' => $selectedQuestion[0][a3],
            'payload' => $fb_id.'#'.$session_id.'#'.$selectedQuestion[0][id].'#'.$selectedQuestion[0][a3].'#'.$selectedQuestion[0][car],
          ],
          [
            'content_type' => 'text',
            'title' => $selectedQuestion[0][a4],
            'payload' => $fb_id.'#'.$session_id.'#'.$selectedQuestion[0][id].'#'.$selectedQuestion[0][a4].'#'.$selectedQuestion[0][car],
          ]
        ]
    ));
    //end issue question
}


try {
  // Receive something
    if (!empty($_REQUEST['hub_mode'])
        && $_REQUEST['hub_mode'] == 'subscribe'
        && $_REQUEST['hub_verify_token'] == $verify_token) {
        // Webhook setup request
        echo $_REQUEST['hub_challenge'];
    } else {
        $data = json_decode(file_get_contents('php://input'), true, 512, JSON_BIGINT_AS_STRING);

        // enable log for debug


        if (!empty($data['entry'][0]['messaging'])) {
            $message = $data['entry'][0]['messaging'][0];
            $fb_id = $message['sender']['id'];
            $log->warning('fb json data:'.var_export(json_encode($data['entry'][0]['messaging']), true));
          // Skipping delivery messages
            if (!empty($message['delivery'])) {
                continue;
            }


            if (!empty($message['message'])) {
                $command = $message['message']['text'];
                $payload = $message['message']['quick_reply']['payload'];
                $log->warning('payload=:'.var_export($payload, true));
            }

            // Handle payload data from QuickReply
            if (!empty($payload)) {
                //verify result, insert answer to database
                $payloadArr = explode('#', $payload);
                $session_id = $payloadArr[1];
                $question_id = $payloadArr[2];
                $submitted_answer = $payloadArr[3];
                $current_car =  $payloadArr[4];
                $is_correct = '';
                $correct_answer = $database->select('question', ['correct'], ['id' => $question_id]);
                if ($submitted_answer == $correct_answer[0]['correct']) {
                    $is_correct = 1;
                } else {
                    $is_correct = 0;
                }
                // $log->warning('$correct_answer='.print_r($correct_answer[0]['correct'],true));
                // $log->warning('$submitted_answer='.print_r($submitted_answer,true));
                // $log->warning('$is_correct='.print_r($is_correct,true));
                $database->update('session', [
                  'correct' => $is_correct,
                  'answer' => $submitted_answer,
                ], [
                'AND' => [
                  'session_id' => $session_id,
                  'question_id' => $question_id,
                ],
                ]);
                nextQuestion($current_car);
            } else {
                // check command here
            }

            // When bot receive message from user
            if (!empty($message['postback'])) {
                $postback= $message['postback']['payload'];
                switch ($postback) {
                    case 'Chọn NEW ERTIGA':
                        $current_car ='ertiga';
                        break;

                    case 'Chọn SWIFT':
                        $current_car ='swift';
                        break;

                    case 'Chọn VITARA':
                        $current_car ='vitara';
                        break;

                    case 'Chọn CIAZ':
                        $current_car ='ciaz';
                        break;

                    default:
                        $current_car ='xxx';
                        break;
                }
                $log->warning('$postback=:'.var_export($postback, true));
                $log->warning('$current_car=:'.var_export($current_car, true));
                nextQuestion($current_car);
            }


            // Handle command
            if (preg_match("/x/i", $command, $matches)) {
                //$bot->send(new Message($fb_id, 'Hãy sẵn sàng để trả lời câu hỏi.'));
                //nextQuestion($current_car);
                //break;
            } elseif (preg_match("/chon xe|chọn xe|select|bat dau|bắt đầu|start/i", $command, $matches)) {
                //do something
                $bot->send(new Message($fb_id, 'Hãy chọn một trong các dòng xe sau để bắt đầu.'));
                $bot->send(new StructuredMessage(
                    $fb_id,
                    StructuredMessage::TYPE_GENERIC,
                    [
                        'elements' => [
                            new MessageElement(
                                'NEW ERTIGA',
                                'Thêm sẻ chia, thêm gắn kết',
                                'http://www.suzuki.com.vn/images/productslider/4w/Ertiga-thumbnail.jpg',
                                [
                                  new MessageButton(MessageButton::TYPE_POSTBACK, 'Chọn NEW ERTIGA'),
                                  new MessageButton(
                                      MessageButton::TYPE_WEB,
                                      'Xem thêm',
                                      'http://suzuki.com.vn/ertiga/'
                                  ),
                                ]
                            ),
                            new MessageElement(
                                'VITARA',
                                'Đậm phong cách, vững thành công',
                                'http://www.suzuki.com.vn/images/productslider/4w/V-thumbnail.jpg',
                                [
                                  new MessageButton(MessageButton::TYPE_POSTBACK, 'Chọn VITARA'),
                                  new MessageButton(
                                      MessageButton::TYPE_WEB,
                                      'Xem thêm',
                                      'http://suzuki.com.vn/ertiga/'
                                  ),
                                ]
                            ),
                            new MessageElement(
                                'SWIFT',
                                'Đơn giản mà đẹp',
                                'http://www.suzuki.com.vn/images/productslider/4w/Swift-thumbnail.jpg',
                                [
                                  new MessageButton(MessageButton::TYPE_POSTBACK, 'Chọn SWIFT'),
                                  new MessageButton(
                                      MessageButton::TYPE_WEB,
                                      'Xem thêm',
                                      'http://suzuki.com.vn/ertiga/'
                                  ),
                                ]
                            ),
                            new MessageElement(
                                'CIAZ',
                                'All-New Suzuki Ciaz Compact Sedan',
                                'http://sanotovietnam.com.vn/upload/2016/8/370-xe-suzuki-ciaz.jpg',
                                [
                                  new MessageButton(MessageButton::TYPE_POSTBACK, 'Chọn CIAZ'),
                                  new MessageButton(
                                      MessageButton::TYPE_WEB,
                                      'Xem thêm',
                                      'http://suzuki.com.vn/'
                                  ),
                                ]
                            ),
                        ],
                    ]
                ));
                break;
            } elseif ($command == 'thoat') {
              //do something
            }
        }
    }
} catch (Exception $e) {
    $log->warning($e->getMessage());
}
