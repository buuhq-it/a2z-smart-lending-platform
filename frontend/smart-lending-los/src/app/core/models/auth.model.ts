export interface LoginRequestModel {
  requestId: string;
  traceId: string;
  requestTime: string;
  body: {
    username: string;
    password: string;
  };
}

export interface JwtModel {
  sub: string;
  username?: string;
  exp?: number;
  [key: string]: any;
}
