export interface User {
  readonly sessionId: number | string;
  readonly mainUrl: string;
  readonly serverUrl: string;
  readonly ethAdress: string;
  readonly data: any[];
}
