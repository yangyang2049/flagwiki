export class ResManager {
  static getPic(value: string | Resource): Resource | string {
    if (typeof value === 'string' && (value.startsWith('http') || value.startsWith('file:'))) {
      return value
    }

    if (value === '' || !value || (typeof value !== 'string' && value.params?.length === 0)) {
      return $r('app.media.song_default')
    }
    return $r(`app.media.${value}`)
  }

  static getColor(value: string): ResourceColor {
    let colorStr: string = 'app.color.' + value
    return $r(colorStr);
  }

  static getFloat(value: string): Length {
    let floatValue: string = 'app.float.' + value
    return $r(floatValue);
  }

  static getString(value: string): Resource {
    let floatValue: string = 'app.string.' + value
    return $r(floatValue);
  }

  static getRawfile(value: string): Resource {
    return $rawfile(value);
  }
}