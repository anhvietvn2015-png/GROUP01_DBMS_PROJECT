def validate_phone(phone):
    if not phone: return None
    phone = str(phone).strip()
    if len(phone) == 10 and phone.startswith('0'):
        phone = phone[1:]
    if len(phone) == 9 and phone.isdigit():
        return phone
    return None

def format_phone_display(phone_9_digits):
    if phone_9_digits:
        p = str(phone_9_digits)
        return f"0{p}" if not p.startswith('0') else p
    return "N/A"

def format_currency(value):
    try:
        return "${:,.2f}".format(float(value))
    except:
        return "$0.00"