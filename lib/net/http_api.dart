import 'package:flutter/foundation.dart';

class HttpApi {
  static const String login = '/api/v1/xadmin/login/';
  static const String logout = '/api/v1/xadmin/logout/';
  static const String upload = 'uuc/upload-inco';
  static const String projectList = "/api/v1/xadmin/concept/project/";

  /// 单个项目下的目录层级
  static const String project_catalog = "/api/v1/xadmin/concept/descendent/";

  /// 单个概念下的对象列表
  static const String object_list = "/api/v1/xadmin/concept/objects/";

  ///获取概念详情数据
  static const String concept_detail = "/api/v1/xadmin/concept/basic/";

  /// 删除概念
  static const String delete_concept = "/api/v1/xadmin/concept/delete/";

  ///获取对象基本信息
  static const String basic_info = "/api/v1/xadmin/object/basic_info";

  /// 获取对象摘要信息
  static const String summary_info = '/api/v1/xadmin/object/summary_info';

  /// 获取bftable 的数据 get
  static const String bftable = '/api/v1/xadmin/object/bftable/';

  ///获取列表属性的数据 get
  static const String list_pro = '/api/v1/xadmin/object/property/pagination';

  /// 短属性添加
  static const String short_pro_add =
      '/api/v1/xadmin/object/short_property/add';

  /// 短属性 修改
  static const String short_pro_edit =
      '/api/v1/xadmin/object/short_property/edit';

  /// 短属性 删除
  static const String short_pro_delete =
      '/api/v1/xadmin/object/short_property/delete';

  /// 获取指定对象所有关联概念
  static const String relation_concept =
      'api/v1/xadmin/object/related_concept/';

  ///============================bmtable==========================///
  ///获取bmtable的数据  get
  static const String bmtable = '/api/v1/xadmin/object/bmtable/';

  ///bmtable    数据删除
  static const String bmtable_remove = '/api/v1/xadmin/object/bmtable/remove';

  ///bmtable    数据添加或修改
  static const String bmtable_edit = '/api/v1/xadmin/object/bmtable/add';

  ///bmtable    批量文本上传
  static const String bmtable_upload = '/api/v1/xadmin/object/bmtable/upload';

  ///bmtable    属性删除
  static const String bmtable_delete = '/api/v1/xadmin/object/bmtable/delete';

  ///bmtable    属性创建
  static const String bmtable_create = '/api/v1/xadmin/object/bmtable/create';

  ///属性修改
  static const String bmtable_pro_edit = '/api/v1/xadmin/object/bmtable/edit';

  ///==========================bftable==============================///

  static const String bftable_Add = '/api/v1/xadmin/object/bftable/add';

  ///bftable数据删除
  static const String bftable_remove = '/api/v1/xadmin/object/bftable/remove';

  static const String bftable_delete = '/api/v1/xadmin/object/bftable/delete';

  /// 以下3个未完成
  static const String bftable_upload = '/api/v1/xadmin/object/bftable/upload';

  static const String bftable_increase =
      '/api/v1/xadmin/object/bftable/increase';

  static const String bftable_create = '/api/v1/xadmin/object/bftable/create';

  static const String bftable_edit_pro = '/api/v1/xadmin/object/bftable/edit';

  ///==========================列表属性=================================
  ///
  /// 列表属性获取
  static const String propertyPagination =
      '/api/v1/xadmin/object/property/pagination';

  /// 列表属性添加
  static const String property_add = 'api/v1/xadmin/object/property/add';

  /// 列表属性修改
  static const String property_edit = '/api/v1/xadmin/object/property/edit';

  ///一般列表类属性单元删除
  static const String property_unit_delete =
      '/api/v1/xadmin/object/property/unit/delete';

  ///一般列表类属性单元添加
  static const String property_unit_add =
      '/api/v1/xadmin/object/property/unit/singal_add';

  /// 一般列表类属性修改单元
  static const String property_unit_edit =
      '/api/v1/xadmin/object/property/unit/edit';

  ///模糊搜索
  static const String searchSmart = '/api/v1/xadmin/search/smart_reminder';

  ///搜索结果
  static const String search_result = '/api/v1/xadmin/search/strict_match/';

  /// 获取动态groupId
  static const String group_id =
      'api/v1/xadmin/resource_proxy/generate_group_id/';

  /// 上传资源服务器
  static const String up_resource = '/resource/up_resource/';

  /// 列表属性删除
  static const String propertyDelete = 'api/v1/xadmin/object/property/delete';

  ///  ====================================关联相关================================///
  ///  获取指定对象所有关联概念
  static const String relatedConcept = 'api/v1/xadmin/object/related_concept/';

  /// 对象关联页获取增强
  static const String objectRelated = 'api/v1/xadmin/object/related/';

  /// 添加关联
  static const String relationLabelAdd = 'api/v1/xadmin/relation/label/add';

  /// 移除关联
  static const String relLabelRemove = 'api/v1/xadmin/relation/label/remove';

  /// 创建关联
  static const String relationCreate = 'api/v1/xadmin/relation/create/';

  static const String relationAdd = 'api/v1/xadmin/relation/add/';

  ///=================================用户============================

  /// 创建用户
  static const String createUser = 'api/v1/xadmin/user/create/';

  /// 已创建用户
  static const String existingUsers = 'api/v1/xadmin/users/';

  /// 项目权限查看
  static const String permissionProject = 'api/v1/xadmin/perssion/project/';
}
