/// EventBus 实体类
class EventObj<T> {
  Event _event;
  T _data;

  EventObj(this._event, this._data);

  Event get event => _event;

  T get data => _data;
}

enum Event {
  search_key,
  replace_object,
}
