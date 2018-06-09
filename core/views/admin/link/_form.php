<?php
/**
 * @link http://www.simpleforum.org/
 * @copyright Copyright (c) 2015 Simple Forum
 * @author Jiandong Yu admin@simpleforum.org
 */

use yii\helpers\Html;
use yii\widgets\ActiveForm;

?>

<?php $form = ActiveForm::begin(); ?>

<?php
	echo $form->field($model, 'name')->textInput(['maxlength' => 20]);
	echo $form->field($model, 'url')->textInput(['maxlength' => 100]);
	echo $form->field($model, 'sortid')->textInput(['maxlength' => 2])->hint('数字越小越靠前，默认99');
?>
	<div class="form-group">
		<?php echo Html::submitButton($model->isNewRecord ? '创建' : '修改', ['class' => 'btn btn-primary']); ?>
	</div>
<?php ActiveForm::end(); ?>
