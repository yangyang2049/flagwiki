/**
 * 手势辅助函数
 * 用于统一处理手表应用中的手势识别
 */

/**
 * 判断是否应该允许从左侧边缘滑动退出页面
 * 
 * @param event 手势事件
 * @param current 当前手势识别器
 * @returns 如果从左侧边缘向右滑动则返回 true，允许退出
 */
export function shouldAllowEdgeSwipeExit(event: BaseGestureEvent, current: GestureRecognizer): boolean {
  if (!current || !current.isBuiltIn()) {
    return false
  }

  if (current.getType() !== GestureControl.GestureType.PAN_GESTURE) {
    return false
  }

  const panEvent = event as PanGestureEvent
  
  // 检查滑动方向：向右滑动（offsetX > 0）
  const isSwipingRight = panEvent?.offsetX > 0
  if (!isSwipingRight) {
    return false
  }

  const target = current.getEventTargetInfo()
  if (!(target instanceof ScrollableTargetInfo)) {
    return false
  }

  const swiperTarget = target as ScrollableTargetInfo
  
  // 第一项：传统的退出手势
  const isAtBeginning = swiperTarget.isBegin()
  if (isAtBeginning) {
    return true
  }

  // 其他位置：检测从左侧边缘滑动
  // 使用 offsetX 的大小作为边缘滑动的判断依据
  // 如果 offsetX 很大（> 100），说明是从边缘开始的长距离滑动
  const offsetX = panEvent?.offsetX ?? 0
  const isLargeSwipe = offsetX > 100
  
  return isLargeSwipe
}
