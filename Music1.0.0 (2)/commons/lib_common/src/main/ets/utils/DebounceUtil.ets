//定义全局放到方法，默认500毫秒，参数类型设为可选参数
export function singleClick(func: Function, interval = 500) {
  let lastTime = 0;
  return () => {
    const nowTime = Date.now();
    const remainTime = interval - (nowTime - lastTime);
    if (remainTime <= 0) {
      lastTime = nowTime;
      func();
    }
  };
}
