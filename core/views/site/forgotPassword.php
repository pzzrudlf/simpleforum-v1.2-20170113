<?php
/**
 * @link http://www.simpleforum.org/
 * @copyright Copyright (c) 2015 Simple Forum
 * @author Jiandong Yu admin@simpleforum.org
 */

use yii\helpers\Html;
use yii\bootstrap\ActiveForm;
use yii\bootstrap\Alert;

$session = Yii::$app->getSession();

$this->title = '通过电子邮件重设密码';
?>

<div class="row">
<!-- sf-left start -->
<div class="col-md-8 sf-left">

<div class="panel panel-default sf-box">
	<div class="panel-heading">
		<?php echo Html::a('首页', ['topic/index']), '&nbsp;/&nbsp;', $this->title; ?>
	</div>
	<div class="panel-body sf-box-form">
<?php
if ( $session->hasFlash('sendPwdNG') ) {
echo Alert::widget([
	   'options' => ['class' => 'alert-warning'],
	   'body' => $session->getFlash('sendPwdNG'),
	]);
}
?>
        <?php $form = ActiveForm::begin([
		    'layout' => 'horizontal',
			'id' => 'form-fogot-password'
		]); ?>
            <?php echo $form->field($model, 'email')->textInput(['maxlength'=>50]); ?>
            <div class="form-group">
				<div class="col-sm-offset-3 col-sm-9">
                <?php echo Html::submitButton('继续', ['class' => 'btn btn-primary']); ?>
				</div>
            </div>
        <?php ActiveForm::end(); ?>
	</div>
</div>

</div>
<!-- sf-left end -->

<!-- sf-right start -->
<div class="col-md-4 sf-right">
<?php echo $this->render('@app/views/common/_right'); ?>
</div>
<!-- sf-right end -->

</div>
