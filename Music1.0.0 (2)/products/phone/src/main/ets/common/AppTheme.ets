import { CustomColors, CustomTheme } from '@kit.ArkUI';

export class AppColorsDefault implements CustomColors {
  //自定义主题色
  brand: ResourceColor = '#FF1949';
  fontPrimary = '#191919';
  fontSecondary = '#666666';
}

export class AppThemeDefault implements CustomTheme {
  public colors: AppColorsDefault = new AppColorsDefault();
}

export const gAppThemeDefault: CustomTheme = new AppThemeDefault();