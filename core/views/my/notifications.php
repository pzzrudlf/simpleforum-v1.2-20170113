<?php
/**
 * @link http://simpleforum.org/
 * @copyright Copyright (c) 2015 Simple Forum
 * @author Jiandong Yu admin@simpleforum.org
 */

use yii\helpers\Html;
use yii\widgets\LinkPager;
use app\models\Notice;
use app\models\Topic;
use app\components\SfHtml;

$this->title = '提醒系统';
$formatter = Yii::$app->getFormatter();

$classSys = [];
$classSms = [];
if( Yii::$app->getRequest()->get('type') == 'sms' ) {
    $classSms = ['class'=>'btn btn-sm btn-primary current'];
} else {
    $classSys = ['class'=>'btn btn-sm btn-primary current'];
}

?>

<div class="row">
<div class="col-md-8 sf-left">

<ul class="list-group sf-box">
    <li class="list-group-item navi-top-list">
    <?php echo Html::a('系统提醒'. ($sysCount>0?'('.$sysCount.')':''), ['my/notifications'], $classSys), Html::a('私信'. ($smsCount>0?'('.$smsCount.')':''), ['my/notifications', 'type'=>'sms'], $classSms); ?>
    </li>
<?php
foreach($notices as $notice) {
    echo '<li class="list-group-item media">',
        SfHtml::uImgLink($notice['source'], 'small', ['class'=>'media-left']),
        '<div class="media-body">
            <span class="fr gray small">', $formatter->asRelativeTime($notice['created_at']), '</span>',
            SfHtml::uLink($notice['source']['username']), ' ';
            if($notice['type'] == Notice::TYPE_COMMENT) {
                echo '回复了您的主题【'. Html::a(Html::encode($notice['topic']['title']), Topic::getRedirectUrl($notice['topic_id'], $notice['position'])) . '】',
                    $notice['notice_count']>0?'<span class="small gray">(省略类似通知'.$notice['notice_count'].'次)</span>':'';
            } else if($notice['type'] == Notice::TYPE_MENTION) {
                if ($notice['position'] > 0) {
                    echo '在主题【'. Html::a(Html::encode($notice['topic']['title']), Topic::getRedirectUrl($notice['topic_id'], $notice['position'])) . '】的回帖中提到了您';
                } else {
                    echo '在主题【'. Html::a(Html::encode($notice['topic']['title']), ['topic/view', 'id'=>$notice['topic_id']]) . '】中提到了您';
                }
            } else if($notice['type'] == Notice::TYPE_FOLLOW_TOPIC) {
                    echo '收藏了您的主题【', Html::a(Html::encode($notice['topic']['title']), ['topic/view', 'id'=>$notice['topic_id']]), '】';
            } else if($notice['type'] == Notice::TYPE_FOLLOW_USER) {
                    echo '关注了您';
            } else if($notice['type'] == Notice::TYPE_MSG) {
                    echo '私信了您。 ', Html::a('<i class="fa fa-reply" aria-hidden="true"></i>回复', ['service/sms', 'id'=>$notice['id']]);
                    echo '<br />', $notice['msg'];
            } else if($notice['type'] == Notice::TYPE_GOOD_TOPIC) {
                    echo '赞了您的主题【', Html::a(Html::encode($notice['topic']['title']), ['topic/view', 'id'=>$notice['topic_id']]), '】';
            } else if($notice['type'] == Notice::TYPE_GOOD_COMMENT) {
                    echo '赞了您在主题【'. Html::a(Html::encode($notice['topic']['title']), Topic::getRedirectUrl($notice['topic_id'], $notice['position'])) . '】里的回复';
            } else if($notice['type'] == Notice::TYPE_CHARGE_POINT) {
                    echo '给您充值积分：'. Html::encode($notice['msg']);
            }
        echo '</div>';
    echo '</li>';
}
?>
    <li class="list-group-item item-pagination">
    <?php
    echo LinkPager::widget([
        'pagination' => $pages,
        'maxButtonCount'=>5,
    ]);
    ?>
    </li>

</ul>
</div>

<div class="col-md-4 sf-right">
<?php echo $this->render('@app/views/common/_right'); ?>
</div>

</div>
