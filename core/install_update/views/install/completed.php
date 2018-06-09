<?php
/**
 * @link http://www.simpleforum.org/
 * @copyright Copyright (c) 2015 Simple Forum
 * @author Jiandong Yu admin@simpleforum.org
 */

use yii\helpers\Html;
use yii\bootstrap\ActiveForm;

$this->title = '论坛安装完成';
?>

<div class="row">
<!-- sf-left start -->
<div class="col-md-8 sf-left">
	<div class="panel panel-default sf-box">
		<div class="panel-heading">
			<?php echo Html::a('极简论坛安装', ['index']), '&nbsp;/&nbsp;', $this->title; ?>
		</div>
		<div class="panel-body">
				<h2>论坛安装完成，请登录管理后台设置论坛信息</h2>
				<?php echo Html::a('管理后台', ['/admin/setting/all']); ?>
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
