export {};

declare global {
  // This declaration causes JSON.parse to return `unknown` instead of `any`.
  interface JSON {
    parse(
      text: string,
      reviver?: (this: any, key: string, value: unknown) => unknown
    ): unknown;
  }
}
