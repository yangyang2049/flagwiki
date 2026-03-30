export interface FlagHistoryItem {
  countryCode: string;
  year: number;
  imagePath: string;
  description?: string;
}

export interface CountryFlagHistory {
  countryCode: string;
  history: FlagHistoryItem[];
}

interface FlagHistoryFeatureModule {
  getFlagHistory(countryCode: string): FlagHistoryItem[];
  getAllFlagHistory(): CountryFlagHistory[];
}

let flagHistoryFeatureModuleCache: FlagHistoryFeatureModule | null = null;
let flagHistoryFeatureModulePromise: Promise<FlagHistoryFeatureModule> | null = null;

async function loadFlagHistoryFeatureModule(): Promise<FlagHistoryFeatureModule> {
  if (flagHistoryFeatureModuleCache) {
    return flagHistoryFeatureModuleCache;
  }
  if (!flagHistoryFeatureModulePromise) {
    flagHistoryFeatureModulePromise = import('flaghistory').then((module: Object) => {
      flagHistoryFeatureModuleCache = module as FlagHistoryFeatureModule;
      return flagHistoryFeatureModuleCache;
    }).catch((error: Object) => {
      flagHistoryFeatureModulePromise = null;
      throw (error instanceof Error ? error : new Error(String(error)));
    });
  }
  return flagHistoryFeatureModulePromise;
}

export async function getFlagHistoryItems(countryCode: string): Promise<FlagHistoryItem[]> {
  const module = await loadFlagHistoryFeatureModule();
  return module.getFlagHistory(countryCode);
}

export async function getAllFlagHistoryItems(): Promise<CountryFlagHistory[]> {
  const module = await loadFlagHistoryFeatureModule();
  return module.getAllFlagHistory();
}
