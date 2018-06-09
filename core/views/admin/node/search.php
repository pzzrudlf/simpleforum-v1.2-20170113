<?php
/**
 * @link http://www.simpleforum.org/
 * @copyright Copyright (c) 2015 Simple Forum
 * @author Jiandong Yu admin@simpleforum.org
 */

use yii\helpers\Html;
use yii\widgets\LinkPager;
use yii\bootstrap\ActiveForm;

$this->title = '节点搜索';
?>

<div class="row">
<!-- sf-left start -->
<div class="col-md-8 sf-left">

<ul class="list-group sf-box">
	<li class="list-group-item">
		<?php
			echo Html::a('论坛管理', ['admin/setting/all']), '&nbsp;/&nbsp;', Html::a('节点管理', ['admin/node/index']), '&nbsp;/&nbsp;', $this->title;
		?>
	</li>
	<li class="list-group-item list-group-item-info"><strong>检索</strong></li>
	<li class="list-group-item sf-box-form">
<?php $form = ActiveForm::begin([
    'layout' => 'horizontal',
	'id' => 'form-setting',
    'fieldConfig' => [
//			        'template' => "{label}\n{beginWrapper}\n{input}\n{hint}\n{error}\n{endWrapper}",
        'horizontalCssClasses' => [
            'label' => 'col-sm-2',
//			            'offset' => 'col-sm-offset-4',
            'wrapper' => 'col-sm-10',
            'error' => '',
            'hint' => 'col-sm-offset-2 col-sm-10',
        ],
    ],
]); ?>
<?php
		echo $form->field($model, "name");
?>
        <div class="form-group">
			<div class="col-sm-offset-2 col-sm-10">
            <?php echo Html::submitButton('搜索', ['class' => 'btn btn-primary', 'name' => 'login-button']); ?>
			</div>
        </div>
<?php
ActiveForm::end();
?>
	</li>
	<li class="list-group-item list-group-item-info"><strong>节点</strong></li>
	<li class="list-group-item">
		<ul>
		<?php
			if( !empty($node) ) {
				echo '<li>[', $node['id'], ']&nbsp;', Html::encode($node['name']), '&nbsp;(', $node['ename'], ')&nbsp;|&nbsp;', Html::a('修改', ['admin/node/edit', 'id'=>$node['id']]), '</li>';
			} else {
				echo '检索的节点不存在';
			}
		?>
		</ul>
	</li>
</ul>

</div>
<!-- sf-left end -->

<!-- sf-right start -->
<div class="col-md-4 sf-right">
<?php echo $this->render('@app/views/common/_admin-right'); ?>
</div>
<!-- sf-right end -->

</div>
