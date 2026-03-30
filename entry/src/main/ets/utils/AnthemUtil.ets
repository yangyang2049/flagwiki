import { Country, getCountriesByContinent } from './countryData';
import { common } from '@kit.AbilityKit';
import {
  initAnthemCache as initAnthemCacheHsp,
  hasAnthemFile as hasAnthemFileHsp,
  getAnthemFilePath as getAnthemFilePathHsp
} from 'anthem';

export async function initAnthemCache(context: common.UIAbilityContext): Promise<void> {
  await initAnthemCacheHsp(context);
}

export function hasAnthemFile(countryCode: string): boolean {
  return hasAnthemFileHsp(countryCode);
}

export function getAnthemFilePath(countryCode: string): string {
  return getAnthemFilePathHsp(countryCode);
}

export function getCountriesWithAnthem(): Country[] {
  const allCountries = getCountriesByContinent('World');
  return allCountries.filter((country: Country) => {
    return hasAnthemFile(country.code);
  });
}
