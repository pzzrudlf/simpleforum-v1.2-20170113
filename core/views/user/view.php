<?php
/**
 * @link http://simpleforum.org/
 * @copyright Copyright (c) 2015 Simple Forum
 * @author Jiandong Yu admin@simpleforum.org
 */

use yii\helpers\Html;
use yii\bootstrap\Alert;
use app\models\Favorite;
use app\models\User;
use app\components\SfHtml;

$this->title = Html::encode($user['username']);
$settings = Yii::$app->params['settings'];
//$editor = new \app\lib\Editor(['editor'=>$settings['editor']]);
$editorClass = '\app\plugins\\'. $settings['editor']. '\\'. $settings['editor'];
$editor = new $editorClass();

$whiteWrapClass = $settings['editor']=='SmdEditor'?'white-wrap':'';

$fomatter = Yii::$app->getFormatter();
$isGuest = Yii::$app->getUser()->getIsGuest();
if (!$isGuest) {
    $me = Yii::$app->getUser()->getIdentity();
}

$userOp = [];
if (!$isGuest && $me->isAdmin() && $me->id != $user['id']) {
    $userOp['manage'] = Html::a('<i class="fa fa-pencil-square-o fa-lg" aria-hidden="true"></i>', ['admin/user/info', 'id'=>$user['id']], ['title'=>'管理']);
}

if (!$isGuest && $me->isActive() && $me->id != $user['id']) {
/*    $follow = Favorite::checkFollow($me->id, Favorite::TYPE_USER, $user['id'])?Html::a('取消特别关注', ['service/unfavorite', 'type'=>'user', 'id'=>$user['id']], [
        'class'=>'btn btn-sm btn-default',
        'data' => [
            'method' => 'post',
        ]]):Html::a('加入特别关注', ['service/favorite', 'type'=>'user', 'id'=>$user['id']], ['class'=>'btn btn-sm btn-primary']);
*/
//    $sms = Html::a('私信Ta', ['service/sms', 'to'=>Html::encode($user['username'])], ['class'=>'btn btn-sm btn-primary']);
    $userOp['sms'] = Html::a('<i class="fa fa-envelope fa-lg" aria-hidden="true"></i>', ['service/sms', 'to'=>Html::encode($user['username'])], ['title' => '私信Ta']);
    $userOp['follow'] = Favorite::checkFollow($me->id, Favorite::TYPE_USER, $user['id'])?Html::a('<i class="fa fa-star fa-lg aria-hidden="true""></i><span class="favorite-num">' . ($user['userInfo']['favorite_count']>0?$user['userInfo']['favorite_count']:'') . '</span>', null, ['class'=>'favorite', 'title'=>'取消关注', 'href' => 'javascript:void(0);', 'params'=>'unfavorite user '. $user['id']]):Html::a('<i class="fa fa-star-o fa-lg" aria-hidden="true"></i><span class="favorite-num">' . ($user['userInfo']['favorite_count']>0?$user['userInfo']['favorite_count']:'') . '</span>', null, ['class'=>'favorite', 'title'=>'关注Ta', 'href' => 'javascript:void(0);', 'params'=>'favorite user '. $user['id']]);
}

?>

<div class="row">
<div class="col-md-8 sf-left">

<div class="panel panel-default sf-box">
    <div class="panel-heading media">
        <div class="media-left item-largeavatar">
            <?php echo SfHtml::uImg($user, 'large'); ?>
        </div>
        <div class="media-body">
            <span class="fr sf-btn"><?php echo implode(' ', $userOp); ?></span>
            <h1 class="media-heading"><?php echo $this->title, '<small>', SfHtml::uGroup($user['score']), '</small>'; ?></h1>
            <p class="gray"><?php echo $settings['site_name'],' 第 ',$user['id'],' 号会员，加入于 ',$fomatter->asDateTime($user['created_at'], 'y-MM-dd HH:mm:ss xxx'); ?>
            </p>
        </div>
    </div>
    <?php if( !empty($user['userInfo']['about']) || !empty($user['userInfo']['website']) ) : ?>
    <div class="panel-body link-external">
        <?php echo empty($user['userInfo']['about'])?'':'<p>'.Html::encode($user['userInfo']['about']).'</p>'; ?>
        <?php echo empty($user['userInfo']['website'])?'':'个人网站： '.Html::a($user['userInfo']['website'], $user['userInfo']['website'], ['target'=>'_blank', 'rel' => 'external']); ?>
    </div>
    <?php endif ?>
</div>

<ul class="list-group sf-box">
    <li class="list-group-item gray"><?php echo Html::encode($user['username']); ?> 最近创建的主题</li>
<?php
foreach($user['topics'] as $topic){
    echo '<li class="list-group-item">
                <h5 class="media-heading">',
                Html::a(Html::encode($topic['title']), ['topic/view', 'id'=>$topic['id']]),
                '</h5>
                <div class="small gray">';
    if($topic['comment_count'] > 0){
        $gotopage = ceil($topic['comment_count']/$settings['comment_pagesize']);
        $url = ['topic/view', 'id'=>$topic['id']];
        if($gotopage > 1){
            $url['p'] = $gotopage;
        }
        echo Html::a($topic['comment_count'], $url, ['class'=>'badge fr count-info']);
    }
                echo Html::a(Html::encode($topic['node']['name']), ['topic/node', 'name'=>$topic['node']['ename']], ['class'=>'btn btn-xs node small']),
                ' •  ', $fomatter->asRelativeTime($topic['replied_at']);
        if ($topic['comment_count']>0) {
                echo '<span class="item-lastreply"> •  最后回复者 ', SfHtml::uLink($topic['lastReply']['username']), '</span>';
        }
                echo '</div>';
    echo '</li>';
}
?>
    <li class="list-group-item">
        » <?php echo Html::a(Html::encode($user['username']).'创建的更多主题', ['topics', 'username'=>Html::encode($user['username'])]); ?>
    </li>
</ul>

<ul class="list-group sf-box">
    <li class="list-group-item gray">
        <?php echo Html::encode($user['username']); ?> 最近回复了
    </li>
<?php
foreach($user['comments'] as $comment) :
?>
    <li class="list-group-item gray small list-group-item-info">
        <p class='fr'><?php echo $fomatter->asRelativeTime($comment['created_at']); ?></p>
        回复了 <?php echo Html::encode($comment['topic']['author']['username']); ?> 创建的主题 › <?php echo Html::a(Html::encode($comment['topic']['title']), ['topic/view', 'id'=>$comment['topic_id']]); ?>
    </li>
    <li class="list-group-item word-wrap <?php echo $whiteWrapClass; ?>">
    <?php
        if ( $comment['invisible'] == 1 || $user['status'] == User::STATUS_BANNED ) {
            echo Alert::widget([
                'options' => ['class' => 'alert-warning'],
                'closeButton'=>false,
                'body' => '此回复已被屏蔽',
            ]);
            if (!$isGuest && $me->isAdmin()) {
                echo $editor->parse($comment['content']);
            }
        } else {
            echo $editor->parse($comment['content']);
        }
    ?>
    </li>
<?php endforeach; ?>
    <li class="list-group-item">
        » <?php echo Html::a(Html::encode($user['username']).'的更多回复', ['comments', 'username'=>Html::encode($user['username'])]); ?>
    </li>
</ul>

</div>

<div class="col-md-4 sf-right">
<?php echo $this->render('@app/views/common/_right'); ?>
</div>

</div>
