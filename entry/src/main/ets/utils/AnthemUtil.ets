import { Country, getCountriesByContinent } from './countryData';
import { common } from '@kit.AbilityKit';
import { getLoadedAnthemFeatureModule, loadAnthemFeatureModule } from './AnthemFeatureLoader';

export async function initAnthemCache(context: common.UIAbilityContext): Promise<void> {
  const anthemFeatureModule = await loadAnthemFeatureModule();
  await anthemFeatureModule.initAnthemCache(context);
}

export function hasAnthemFile(countryCode: string): boolean {
  const anthemFeatureModule = getLoadedAnthemFeatureModule();
  return anthemFeatureModule ? anthemFeatureModule.hasAnthemFile(countryCode) : false;
}

export function getAnthemFilePath(countryCode: string): string {
  const anthemFeatureModule = getLoadedAnthemFeatureModule();
  return anthemFeatureModule
    ? anthemFeatureModule.getAnthemFilePath(countryCode)
    : `anthems/anthem_${countryCode.toLowerCase()}.ogg`;
}

export function getCountriesWithAnthem(): Country[] {
  const allCountries = getCountriesByContinent('World');
  return allCountries.filter((country: Country) => {
    return hasAnthemFile(country.code);
  });
}
