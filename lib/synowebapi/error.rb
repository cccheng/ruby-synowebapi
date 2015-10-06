
module SYNOWebAPI

  ERRNO = {
    100 => 'unknown error',
    101 => 'bad request',
    102 => 'API not found',
    103 => 'method not found',
    104 => 'unsupported version',
    105 => 'no permission',
    106 => 'session timeout',
    107 => 'session interrupted',
    108 => 'handling upload',
    109 => 'process relay',
    110 => 'process entry',
    111 => 'process lib',
    112 => 'compound stop',
    113 => 'compound reject',
    114 => 'no required parameter',
    115 => 'denied in upload mode',
    116 => 'denied in demo mode',
    117 => 'internal error',
    118 => 'process name error',
    119 => 'session not found',
    120 => 'invalid request parameter',
    121 => 'mismatched lib entry',
    122 => 'sharing session not found',
    123 => 'sharing error token',
    124 => 'sharing invalid entry',
    125 => 'sharing timeout',
    126 => 'sharing no permission',
    127 => 'sharing no app permission',
    400 => 'authentication failed',
    401 => 'account disabled',
    402 => 'permission denied',
    403 => 'OTP code required',
    404 => 'OTP code incorrect',
    405 => 'App portal incorrect',
    406 => 'OTP code enforced',
    407 => 'max tries by auto blocking',
  }

  module ErrorHandler
    def error_handling(error)
      code = error['code']
      if ERRNO.has_key?(code)
        raise StandardError.new(ERRNO[code])
      else
        raise StandardError.new(code)
      end
    end
  end
end
